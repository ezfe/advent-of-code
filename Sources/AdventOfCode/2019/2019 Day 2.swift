//
//  File.swift
//  
//
//  Created by Ezekiel Elin on 10/20/20.
//

import Foundation

struct Day2019_2: Day {
	func run(input: String) async -> (Int?, Int?) {
		let program = input.filter { !$0.isWhitespace }.split(separator: ",").map { str in
			return Int(str)!
		}
		
		let part1: Int
		do {
			var computer = IntcodeState(memory: program)
			computer.memory[1] = 12
			computer.memory[2] = 2
			part1 = computer.evaluate()
		}
		
		var part2: Int? = nil
		do {
			let _ = await concurrentPerform(input: Array(0..<99)) { i1 -> Void in
				for i2 in 0...99 {
					var computer = IntcodeState(memory: program)
					computer.memory[1] = i1
					computer.memory[2] = i2
					let result = computer.evaluate()
					if result == 19690720 {
						part2 = 100 * i1 + i2
						break
					}
				}
			}
		}
		
		return (part1, part2)
	}
}
