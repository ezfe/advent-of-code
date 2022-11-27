//
//  2020 Day 1.swift
//  
//
//  Created by Ezekiel Elin on 12/1/20.
//

import Foundation

struct Day2021_2: Day {
	enum Instruction {
		case forward(Int)
		case down(Int)
		case up(Int)
	}
	
	func run(input: String) {
		let instructions = input
			.split(whereSeparator: \.isNewline)
			.map { line -> Instruction in
				let tokens = line.split(separator: " ")
				let ins = tokens[0]
				let x = Int(tokens[1])!
				switch ins {
					case "forward":
						return .forward(x)
					case "down":
						return .down(x)
					case "up":
						return .up(x)
					default:
						fatalError("Invalid instruction: \(ins)")
						
				}
			}
		
		part1(instructions: instructions)
		part2(instructions: instructions)
	}
	
	func part1(instructions: [Instruction]) {
		var x = 0
		var depth = 0
		for ins in instructions {
			switch ins {
				case .forward(let distance):
					x += distance
				case .down(let height):
					depth += height
				case .up(let height):
					depth -= height
			}
		}
		
		print(x * depth)
	}
	
	func part2(instructions: [Instruction]) {
		var x = 0
		var depth = 0
		var aim = 0
		
		for instruction in instructions {
			switch instruction {
				case .down(let change):
					aim += change
				case .up(let change):
					aim -= change
				case .forward(let change):
					x += change
					depth += aim * change
			}
		}
		
		print(x * depth)
	}
}
