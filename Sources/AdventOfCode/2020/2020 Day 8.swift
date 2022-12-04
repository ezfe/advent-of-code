//
//  2020 Day 8.swift
//  
//
//  Created by Ezekiel Elin on 12/8/20.
//

import Foundation

struct Day2020_8: Day {
	func run(input: String) -> (Int?, Int?) {
		let lines = input.split(whereSeparator: \.isNewline).map(String.init)
		let ops = lines.map { Operation.parse(line: $0) }
		
		// Part 1
		let (_, acc1) = terminates(ops: ops)
		
		// Part 2
		for i in 0..<ops.count {
			var modified = ops
			switch modified[i] {
				case .nop(let x):
					modified[i] = .jmp(x)
				case .jmp(let x):
					modified[i] = .nop(x)
				default:
					continue
			}
			let (ends, acc2) = terminates(ops: modified)
			if ends {
				print(acc2)
				return (acc1, acc2)
			}
		}
		return (acc1, nil)
	}
	
	func terminates(ops: [Operation]) -> (terminated: Bool, acc: Int) {
		var pc = 0
		var visited = Set<Int>()
		var accumulator = 0
		while true {
			if pc >= ops.count {
				return (true, accumulator)
			} else if visited.contains(pc) {
				return (false, accumulator)
			} else {
				visited.insert(pc)
			}
			switch ops[pc] {
				case .nop(_):
					pc += 1
				case .acc(let amount):
					pc += 1
					accumulator += amount
				case .jmp(let amount):
					pc += amount
			}
		}
	}
	
	enum Operation {
		case nop(Int)
		case acc(Int)
		case jmp(Int)
		
		static func parse(line: String) -> Operation {
			let tokens = line.split(separator: " ")
			let number = Int(tokens[1])!
			switch tokens[0] {
				case "nop":
					return .nop(number)
				case "acc":
					return .acc(number)
				case "jmp":
					return .jmp(number)
				default:
					print("Failed to parse \(line)")
					exit(1)
			}
		}
	}
}
