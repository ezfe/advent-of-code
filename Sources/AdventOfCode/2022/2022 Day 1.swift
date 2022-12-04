//
//  2022 Day 1.swift
//  
//
//  Created by Ezekiel Elin on 11/30/22.
//

struct Day2022_1: Day {
	func run(input: String) -> (Int?, Int?) {
		let elves = input
			.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)
			.split(whereSeparator: \.isEmpty)
			.map { $0.map(\.integer).sum() }
		
		return (elves.max()!, elves.max(count: 3).sum())
	}
}
