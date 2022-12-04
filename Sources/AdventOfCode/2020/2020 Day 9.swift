//
//  2020 Day 9.swift
//
//
//  Created by Ezekiel Elin on 12/9/20.
//

import Foundation

struct Day2020_9: Day {
	func run(input: String) -> (Int?, Int?) {
		let lines = input.split(whereSeparator: \.isNewline).map(\.integer)
		
		let p1 = part1(lines: lines)
		let p2 = part2(lines: lines, part1: p1)
		
		return (p1, p2)
	}
	
	func part1(lines: [Int]) -> Int {
		func check(list: ArraySlice<Int>, targetSum: Int) -> Bool {
			for a in list {
				let b = targetSum - a
				if list.contains(b) {
					return true
				}
			}
			return false
		}
		
		for i in 25..<lines.count {
			let range = lines[(i - 25)..<i]
			if !check(list: range, targetSum: lines[i]) {
				return lines[i]
			}
		}
		exit(1)
	}
	
	func part2(lines: [Int], part1 p1: Int) -> Int {
	ml: for lower in 0..<lines.count {
		for upper in (lower + 1)..<lines.count {
			let subset = lines[lower...upper]
			let sum = subset.reduce(0, +)
			
			if sum > p1 {
				continue ml
			} else if sum == p1 {
				return subset.min()! + subset.max()!
			}
		}
	}
		exit(1)
	}
}
