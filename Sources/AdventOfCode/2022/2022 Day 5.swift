//
//  2022 Day 5.swift
//  
//
//  Created by Ezekiel Elin on 12/5/22.
//

import Foundation

struct Day2022_5: Day {
	struct Move {
		let source: Int
		let destination: Int
		let count: Int
	}
	
	func run(input: String) async -> (String?, String?) {
		let sections = input.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline).split(whereSeparator: \.isEmpty)
		
		let stackIndexes = sections[0].last!
			.enumerated()
			.filter { !$0.element.isWhitespace }
			.map { (offset: $0.offset, element: String($0.element).integer - 1) }
		
		let stackLines = sections[0].reversed().dropFirst().map { $0.enumerated() }
		
		var stacks = Array(repeating: [Character](), count: stackIndexes.map(\.element).max()! + 1)
		for line in stackLines {
			let arr = Array(line)
			for (offset, stackIndex) in stackIndexes {
				if offset < arr.count && !arr[offset].element.isWhitespace {
					stacks[stackIndex].append(arr[offset].element)
				}
			}
		}
		
		let moves = sections[1].map { section in
			let regex = #/move (?<count>[0-9]+) from (?<source>[0-9]+) to (?<destination>[0-9]+)/#
			let match = section.firstMatch(of: regex)!
			return Move(source: match.source.integer, destination: match.destination.integer, count: match.count.integer)
		}
		
		return (part1(stacks: stacks, moves: moves), part2(stacks: stacks, moves: moves))
	}
	
	func part1(stacks: [[Character]], moves: [Move]) -> String {
		var stacks = stacks
		for move in moves {
			for _ in 0..<move.count {
				let item = stacks[move.source - 1].removeLast()
				stacks[move.destination - 1].append(item)
			}
		}
		
		return stacks.map { String($0.last!) }.joined()
	}

	func part2(stacks: [[Character]], moves: [Move]) -> String {
		var stacks = stacks
		for move in moves {
			var items = [Character]()
			for _ in 0..<move.count {
				items.append(stacks[move.source - 1].removeLast())
			}
			stacks[move.destination - 1].append(contentsOf: items.reversed())
		}
		
		return stacks.map { String($0.last!) }.joined()
	}
}
