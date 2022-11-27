//
//  2020 Day 14.swift
//  
//
//  Created by Ezekiel Elin on 12/14/20.
//

import Foundation

struct Day2020_14: Day {
	enum Operation {
		case mask(mask: String)
		case update(position: UInt64, value: UInt64)
	}
	func run(input: String) {
		let lines = input.split(whereSeparator: \.isNewline).map { line -> Operation in
			if line.starts(with: "mask = ") {
				return .mask(mask: String(line.dropFirst(7)))
			} else {
				let split = line.split(separator: "]")
				
				let posString = split[0].dropFirst(4)
				let valueString = split[1].dropFirst(3)
				
				let position = UInt64(posString)!
				let value = UInt64(valueString)!
				
				return .update(position: position, value: value)
			}
		}
		
		part2(lines: lines)
	}
	
	func part1(lines: [Operation]) {
		func process(_ value: UInt64, with mask: String) -> UInt64 {
			/*
			 mask = 1100XX
			 proc = 000011
			 */
			let _xmask = mask.replacingOccurrences(of: "1", with: "0").replacingOccurrences(of: "X", with: "1")
			let xmask = UInt64(_xmask, radix: 2)!
			
			// value let through the mask
			let kept = value & xmask
			
			let _ymask = mask.replacingOccurrences(of: "X", with: "0")
			let ymask = UInt64(_ymask, radix: 2)!
			
			let combined = kept | ymask
			
			return combined
		}
		
		var currentMask = String(repeating: "X", count: 36)
		var storage = [UInt64:UInt64]()
		
		for operation in lines {
			switch operation {
				case .mask(mask: let mask):
					currentMask = mask
				case .update(position: let position, value: let value):
					storage[position] = process(value, with: currentMask)
			}
		}
		
		print(storage.values.reduce(0, +))
	}
	
	func part2(lines: [Operation]) {
		func process(_ position: UInt64, with mask: String, at i: Int) -> Character {
			let mask = Array(mask.reversed())
			let valueString = String(position, radix: 2)
			let _value = (Array(String(repeating: "0", count: 36 - valueString.count)) + Array(valueString)).reversed()
			let value = Array(_value)
			
			if mask[i] == "0" {
				return value[i]
			} else if mask[i] == "1" {
				return "1"
			} else {
				return "X"
			}
		}
		
		var currentMask = String(repeating: "0", count: 36)
		var storage = [UInt64:UInt64]()
		
		for operation in lines {
			switch operation {
				case .mask(mask: let mask):
					currentMask = mask
				case .update(position: let position, value: let value):
					var working = [UInt64]()
					/* Index 0 */
					switch process(position, with: currentMask, at: 0) {
						case "X":
							working.append(1)
							working.append(0)
						case "1":
							working.append(1)
						case "0":
							working.append(0)
						default:
							print("Unexpected process response...")
							exit(1)
					}
					for i in 1..<36 {
						let p = process(position, with: currentMask, at: i)
						
						switch p {
							case "X":
								working = working.map { addr -> [UInt64] in
									return [(1 << i) | addr, addr]
								}.reduce([], +)
							case "1":
								working = working.map { addr -> UInt64 in
									return (1 << i) | addr
								}
							default:
								break
						}
					}
					for addr in working {
						storage[addr] = value
					}
			}
		}
		
		print(storage.values.reduce(0, +))
	}
}
