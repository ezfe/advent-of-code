//
//  2022 Day 4.swift
//  
//
//  Created by Ezekiel Elin on 12/4/22.
//

import Foundation

struct Day2022_4: Day {
	func run(input: String) async {
		let ranges = input.split(whereSeparator: \.isNewline)
			.map { $0.split(separator: ",") }
			.map { line in
				let numbers = line.map { $0.split(separator: "-").map(\.integer) }
				return (numbers[0][0]...numbers[0][1], numbers[1][0]...numbers[1][1])
			}
		
		let withFullSubset = ranges.filter { pair in
			let r1 = pair.0
			let r2 = pair.1
			
			return r1.fullyContains(other: r2) || r2.fullyContains(other: r1)
		}
		
		let withPartialOverlap = ranges.filter { pair in
			let r1 = pair.0
			let r2 = pair.1
			
			return r1.overlaps(r2)
		}
		
		print(withFullSubset.count)
		print(withPartialOverlap.count)
	}
}
