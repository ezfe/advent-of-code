//
//  File.swift
//  
//
//  Created by Ezekiel Elin on 10/20/20.
//

import Foundation

protocol IntcodeInput {
    mutating func read() -> Int?
}

protocol IntcodeOutput {
    mutating func write(_ int: Int)
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

struct IntcodeState {
    var memory: [Int]
    var pointer: Int
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

    mutating func readReferenced(mode: Int = 0) -> Int {
        switch mode {
        case 0:
            return self.memory[self.read()]
        case 1:
            return self.read()
        default:
            print("Unexpected parameter mode \(mode)")
            exit(2)
        }
    }

    mutating func read() -> Int {
        let value = self.memory[self.pointer]
        self.pointer += 1
        return value
    }

    mutating func write(_ value: Int, to addr: Int) {
        self.memory[addr] = value
    }

    mutating func writeReferenced(_ value: Int) {
        let address = self.read()
        self.memory[address] = value
    }

    static func advanceOnce(_ state: IntcodeState) -> IntcodeState {
        // This function is static to prevent accidently
        // using properties of `self` instead of `state`.
        // Since it's not a mutating function, it cannot work
        // in-place, and using `self` could be dangerous even if non-mutating.

        if state.halted {
            return state
        }

        var state = state

        let checkpoint = state.pointer
        let instruction = state.read()

        switch instruction % 100 {
        case 1:
            let val1 = state.readReferenced(mode: parseMode(n: 0, opcode: instruction))
            let val2 = state.readReferenced(mode: parseMode(n: 1, opcode: instruction))

            let targetAddress = state.read()

            state.write(val1 + val2, to: targetAddress)
        case 2:
            let val1 = state.readReferenced(mode: parseMode(n: 0, opcode: instruction))
            let val2 = state.readReferenced(mode: parseMode(n: 1, opcode: instruction))

            let targetAddress = state.read()

            state.write(val1 * val2, to: targetAddress)
        case 3:
            guard let val1 = state.input.read() else {
                state.pointer = checkpoint
                state.paused = true
                return state
            }
            state.writeReferenced(val1)
        case 4:
            let val1 = state.readReferenced(mode: parseMode(n: 0, opcode: instruction))
            state.output.write(val1)
        case 5:
            let val1 = state.readReferenced(mode: parseMode(n: 0, opcode: instruction))
            let val2 = state.readReferenced(mode: parseMode(n: 1, opcode: instruction))
            if val1 != 0 {
                state.pointer = val2
            }
        case 6:
            let val1 = state.readReferenced(mode: parseMode(n: 0, opcode: instruction))
            let val2 = state.readReferenced(mode: parseMode(n: 1, opcode: instruction))
            if val1 == 0 {
                state.pointer = val2
            }
        case 7:
            let val1 = state.readReferenced(mode: parseMode(n: 0, opcode: instruction))
            let val2 = state.readReferenced(mode: parseMode(n: 1, opcode: instruction))

            let targetAddress = state.read()

            state.write(val1 < val2 ? 1 : 0, to: targetAddress)
        case 8:
            let val1 = state.readReferenced(mode: parseMode(n: 0, opcode: instruction))
            let val2 = state.readReferenced(mode: parseMode(n: 1, opcode: instruction))

            let targetAddress = state.read()

            state.write(val1 == val2 ? 1 : 0, to: targetAddress)
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
