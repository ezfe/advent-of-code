//
//  File.swift
//  
//
//  Created by Ezekiel Elin on 10/20/20.
//

import Foundation

// MARK:- IO

protocol IntcodeInput {
    mutating func read() -> Int?
}

protocol IntcodeOutput {
    mutating func write(_ int: Int)
}

class BufferedIO: IntcodeInput, IntcodeOutput, CustomStringConvertible {
    var stream: [Int]

    init() {
        self.stream = []
    }

    func write(_ int: Int) {
        stream.append(int)
    }

    func read() -> Int? {
        if stream.count > 0 {
            return stream.removeFirst()
        } else {
            return nil
        }
    }

    var description: String {
        return "{Pipe | Contents: \(stream.description)}"
    }
}

struct UserIO: IntcodeInput, IntcodeOutput {
    func read() -> Int? {
        print("> ", terminator: "")
        return Int(readLine() ?? "")!
    }

    func write(_ int: Int) {
        print(int)
    }
}

struct PreloadedStream: IntcodeInput {
    var stream: [Int]

    init(stream: [Int]) {
        self.stream = stream
    }

    mutating func read() -> Int? {
        return stream.removeFirst()
    }
}

// MARK:- Primary Class

struct IntcodeState {
    var memory: [Int]
    var pointer: Int
    var relativeBase = 0

    var halted: Bool {
        return memory[pointer] == 99
    }
    var paused = false
    var input: IntcodeInput
    var output: IntcodeOutput

    init(memory: [Int],
         input: IntcodeInput = UserIO(),
         output: IntcodeOutput = UserIO()) {

        self.memory = memory
        self.pointer = 0
        self.input = input
        self.output = output
    }

    static func parseMode(n: Int, opcode: Int) -> Int {
        let multiplier = Int(pow(10.0, Double(n)))
        let modes = opcode / (100 * multiplier)
        return modes % 10
    }

    mutating func readParameter(number index: Int, opcode: Int) -> Int {
        let mode = IntcodeState.parseMode(n: index, opcode: opcode)

        switch mode {
        case 0:
            return self.safeRead(at: self.read())
        case 1:
            return self.read()
        case 2:
            return self.safeRead(at: self.relativeBase + self.read())
        default:
            print("Unexpected parameter mode \(mode)")
            exit(2)
        }
    }

    mutating func read() -> Int {
        let value = self.safeRead(at: self.pointer)
        self.pointer += 1
        return value
    }

    mutating func safeRead(at addr: Int) -> Int {
        while addr >= self.memory.count {
            self.memory.append(0)
        }
        return self.memory[addr]
    }

    mutating func write(_ value: Int, to addr: Int) {
        while addr >= self.memory.count {
            self.memory.append(0)
        }
        self.memory[addr] = value
    }

    mutating func writeReferenced(_ value: Int, number index: Int, opcode: Int) {
        let mode = IntcodeState.parseMode(n: index, opcode: opcode)

        switch mode {
        case 0:
            self.write(value, to: self.read())
        case 2:
            self.write(value, to: self.relativeBase + self.read())
        default:
            print("Unexpected parameter mode \(mode)")
            exit(2)
        }
    }

    // MARK:- Primary Loop

    static func advanceOnce(_ state: IntcodeState) -> IntcodeState {
        // This function is static to prevent accidently
        // using properties of `self` instead of `state`.
        // Since it's not a mutating function, it cannot work
        // in-place, and using `self` could be dangerous even if non-mutating.

        if state.halted {
            return state
        }

        var state = state

        // Un-pause the computer to resume computations
        state.paused = false

        let checkpoint = state.pointer
        let instruction = state.read()

        switch instruction % 100 {
        case 1:
            let val1 = state.readParameter(number: 0, opcode: instruction)
            let val2 = state.readParameter(number: 1, opcode: instruction)
            state.writeReferenced(val1 + val2, number: 2, opcode: instruction)
        case 2:
            let val1 = state.readParameter(number: 0, opcode: instruction)
            let val2 = state.readParameter(number: 1, opcode: instruction)
            state.writeReferenced(val1 * val2, number: 2, opcode: instruction)
        case 3:
            guard let val1 = state.input.read() else {
                state.pointer = checkpoint
                state.paused = true
                return state
            }
            state.writeReferenced(val1, number: 0, opcode: instruction)
        case 4:
            let val1 = state.readParameter(number: 0, opcode: instruction)
            state.output.write(val1)
        case 5:
            let val1 = state.readParameter(number: 0, opcode: instruction)
            let val2 = state.readParameter(number: 1, opcode: instruction)
            if val1 != 0 {
                state.pointer = val2
            }
        case 6:
            let val1 = state.readParameter(number: 0, opcode: instruction)
            let val2 = state.readParameter(number: 1, opcode: instruction)
            if val1 == 0 {
                state.pointer = val2
            }
        case 7:
            let val1 = state.readParameter(number: 0, opcode: instruction)
            let val2 = state.readParameter(number: 1, opcode: instruction)
            state.writeReferenced(val1 < val2 ? 1 : 0, number: 2, opcode: instruction)
        case 8:
            let val1 = state.readParameter(number: 0, opcode: instruction)
            let val2 = state.readParameter(number: 1, opcode: instruction)
            state.writeReferenced(val1 == val2 ? 1 : 0, number: 2, opcode: instruction)
        case 9:
            let val1 = state.readParameter(number: 0, opcode: instruction)
            state.relativeBase += val1
        default:
            print("Encountered unexpected instruction \(instruction)")
            exit(1)
        }

        return state
    }

    static func advanceMulti(_ state: IntcodeState) -> IntcodeState {
        if state.halted { return state }

        var state = state
        repeat {
            state = IntcodeState.advanceOnce(state)
        } while !state.halted && !state.paused
        return state
    }

    @discardableResult
    func evaluate() -> Int {
        return IntcodeState.advanceMulti(self).memory[0]
    }
}
