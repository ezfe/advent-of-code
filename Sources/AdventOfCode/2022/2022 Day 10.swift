//
//  2022 Day 10.swift
//  
//
//  Created by Ezekiel Elin on 12/9/22.
//

import Foundation

struct Day2022_10: Day {
	enum Op {
		case noop
		case addx(Int)
	}

	func run(input: String) async -> (Int?, Int?) {
		let ops = input.split(whereSeparator: \.isNewline).map { (line: Substring) in
			if line.starts(with: "noop") {
				return Op.noop
			} else if line.starts(with: "addx") {
				return Op.addx(Int(line.dropFirst(5))!)
			}
			fatalError("line: \(line)")
		}
		
		var x = 1
		var cycle = 0
		var part1 = 0
		for op in ops {
			switch op {
				case .addx(let v):
					part1 += cycleLoop(cycle: &cycle, x: x)
					part1 += cycleLoop(cycle: &cycle, x: x)
					x += v
				case .noop:
					part1 += cycleLoop(cycle: &cycle, x: x)
			}
		}
		
		return (part1, nil)
	}
	
	func cycleLoop(cycle: inout Int, x: Int) -> Int {
		// Part 1
		cycle += 1
		var returnVal = 0
		if (cycle - 20) % 40 == 0 {
			returnVal = cycle * x
		}
		
		// Part 2
		if (x - 1)...(x + 1) ~= ((cycle - 1) % 40) {
			print("#", terminator: "")
		} else {
			print(".", terminator: "")
		}
		if (cycle - 1) % 40 == 39 {
			print("")
		}
		
		// Part 1
		return returnVal
	}
}
