//
//  2020 Day 6.swift
//  
//
//  Created by Ezekiel Elin on 12/5/20.
//

import Foundation

struct Day2020_6: Day {
	func run(input: String) -> (Int?, Int?) {
		let lines = input.split(omittingEmptySubsequences: false, whereSeparator: \.isWhitespace).map(String.init)
		let groups = lines.split(whereSeparator: { $0.isEmpty })
		
		return (run1(groups: groups), run2(groups: groups))
	}
	
	func run1(groups: [Array<String>.SubSequence]) -> Int {
		let setted: [Set<Character>] = groups.map {
			return Set($0.reduce([], +))
		}
		
		return setted.map(\.count).sum()
	}
	
	func run2(groups: [Array<String>.SubSequence]) -> Int {
		let setted: [Set<Character>] = groups.map { lines in
			let sets = lines.map(Set.init)
			guard var working = sets.first else {
				return []
			}
			for set in sets.dropFirst() {
				working = working.intersection(set)
			}
			return working
		}
		
		return setted.map(\.count).sum()
	}
}
