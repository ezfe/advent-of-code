//
//  File.swift
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
			
			return (r1 ~= r2.lowerBound && r1 ~= r2.upperBound) || (r2 ~= r1.lowerBound && r2 ~= r1.upperBound)
		}
		
		let withPartialOverlap = ranges.filter { pair in
			let r1 = pair.0
			let r2 = pair.1
			
			return r1 ~= r2.lowerBound || r1 ~= r2.upperBound || r2 ~= r1.lowerBound || r2 ~= r1.upperBound
		}
		
		print(withFullSubset.count)
		print(withPartialOverlap.count)
	}
}
