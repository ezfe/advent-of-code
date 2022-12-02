//
//  2020 Day 13.swift
//
//
//  Created by Ezekiel Elin on 12/13/20.
//

import Foundation
import Atomics

struct Day2020_13: Day {
	func run(input: String) async {
		let lines = input.split(whereSeparator: \.isNewline)
		
		part1(lines: lines)
		await part2(lines: lines)
	}
	
	func part1<T: StringProtocol>(lines: [T]) {
		let earliestDeparture = Int(lines[0])!
		let routes = lines[1].split(separator: ",").compactMap { Int($0) }
		
		let (untilNextDeparture, selectedRoute) = routes.map { route in
			let sinceMostRecent = earliestDeparture % route
			let untilNextDeparture = route - sinceMostRecent
			
			return (untilNextDeparture, route)
		}.sorted { $0.0 < $1.0 }.first!
		
		print(selectedRoute * untilNextDeparture)
	}
	
	func part2<T: StringProtocol>(lines: [T]) async {
		let coreCount = UInt(8)
		let routes = lines[1].split(separator: ",").map { rid in
			return Int(rid)
		}
		
		await withTaskGroup(of: UInt.self) { group in
			for offset in 0..<coreCount {
				group.addTask {
					return eval(offset: offset)
				}
			}
			
			print("Created group with 8 offsets, awaiting...")

			let result = await group.first(where: { $0 > 0 })
			print(result ?? "No result")
			group.cancelAll()
		}
		
		@Sendable
		func eval(offset: UInt) -> UInt {
			var i = offset
			while i < UInt.max - coreCount {
				if eval(start: i) {
					return i
				} else {
					i += coreCount
				}
			}
			return 0
		}
		
		@Sendable
		func eval(start: UInt) -> Bool {
			for (i, route) in routes.enumerated() {
				if let route, (start + UInt(i)) % UInt(route) != 0 {
					return false
				}
			}
			return true
		}
	}
}
