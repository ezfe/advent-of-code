//
//  2021 Day 7.swift
//  
//
//  Created by Ezekiel Elin on 11/29/22.
//

import Foundation

struct Day2021_7: Day {
	func run(input: String) -> (Int?, Int?) {
		let positions = input.split(separator: ",").map(\.integer)
		
		let min = positions.min()!
		let max = positions.max()!
		
		return (part1(positions: positions, min: min, max: max), part2(positions: positions, min: min, max: max))
	}
	
	func part1(positions: [Int], min: Int, max: Int) -> Int {
		let results = (min...max).map { proposed in
			let expenses = positions.map { abs($0 - proposed) }.reduce(0, +)
			return (proposed, expenses)
		}.sorted {
			$0.1 < $1.1
		}
		
		return results.first!.1
	}
	
	func part2(positions: [Int], min: Int, max: Int) -> Int {
		let results = (min...max).map { proposed in
			let expenses = positions.map { start in
				let diff = abs(start - proposed)
				return (Int(pow(Double(diff), 2)) + diff) / 2
			}.reduce(0, +)
			return (proposed, expenses)
		}.sorted {
			$0.1 < $1.1
		}
		
		return results.first!.1
	}
}
