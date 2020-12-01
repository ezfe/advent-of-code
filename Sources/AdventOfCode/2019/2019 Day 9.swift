//
//  File.swift
//
//
//  Created by Ezekiel Elin on 10/21/20.
//

import Foundation

struct Day2019_9: Day {
    func run(input: String) {
        let program = input.filter { !$0.isWhitespace }.split(separator: ",").map { str in
            return Int(str)!
        }

        let computer = IntcodeState(memory: program)
        computer.evaluate()
    }
}
