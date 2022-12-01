//
//  2022 Day 1.swift
//  
//
//  Created by Ezekiel Elin on 12/1/20.
//

struct Day2022_1: Day {
	func run(input: String) {
		let elves = input
			.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)
			.split(whereSeparator: \.isEmpty)
			.map { $0.compactMap(\.integer).sum() }
		
		print(elves.max()!)
		print(elves.max(count: 3).sum())
	}
}
