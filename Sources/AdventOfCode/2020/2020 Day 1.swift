//
//  2020 Day 1.swift
//  
//
//  Created by Ezekiel Elin on 12/1/20.
//

import Foundation
import Algorithms

struct Day2020_1: Day {
	func run(input: String) {
		let lines = input.split(whereSeparator: \.isNewline).map { Int($0)! }
		
		routine(lines: lines, parameter: 2)
		routine(lines: lines, parameter: 3)
	}
	
	func routine(lines: [Int], parameter: Int) {
		for combo in lines.combinations(ofCount: parameter) {
			if combo.reduce(0, +) == 2020 {
				print(combo.reduce(1, *))
				break
			}
		}
	}
}
