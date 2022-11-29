//
//  2021 Day 6.swift
//  
//
//  Created by Ezekiel Elin on 12/1/20.
//

import Foundation
import RegexBuilder

struct Day2021_7: Day {
	func run(input: String) {
		let positions = input.split(separator: ",").map { Int($0)! }
		
		let min = positions.min()!
		let max = positions.max()!
		
		part1(positions: positions, min: min, max: max)
		part2(positions: positions, min: min, max: max)
	}
	
	func part1(positions: [Int], min: Int, max: Int) {
		let results = (min...max).map { proposed in
			let expenses = positions.map { abs($0 - proposed) }.reduce(0, +)
			return (proposed, expenses)
		}.sorted {
			$0.1 < $1.1
		}
		
		print(results[0].1)
	}
	
	func part2(positions: [Int], min: Int, max: Int) {
		let results = (min...max).map { proposed in
			let expenses = positions.map { start in
				let diff = abs(start - proposed)
				return (Int(pow(Double(diff), 2)) + diff) / 2
			}.reduce(0, +)
			return (proposed, expenses)
		}.sorted {
			$0.1 < $1.1
		}
		
		print(results[0].1)
	}
}
