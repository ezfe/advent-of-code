//
//  2022 Day 1.swift
//  
//
//  Created by Ezekiel Elin on 12/1/20.
//

import Foundation
import Algorithms

struct Day2022_1: Day {
	func run(input: String) {
		let elves = input.split(separator: #/\n\n/#).map { $0.split(whereSeparator: \.isNewline).map { Int($0)! } }
		
		let top3 = elves.map { $0.reduce(0, +) }.sorted().reversed()[0..<3]
		
		print(top3.first!)
		print(top3.reduce(0, +))
	}
}
