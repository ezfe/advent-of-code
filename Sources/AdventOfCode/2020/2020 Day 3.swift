//
//  2020 Day 3.swift
//  
//
//  Created by Ezekiel Elin on 12/3/20.
//

import Foundation

struct Day2020_3: Day {
	enum Cell {
		case open, tree
	}
	
	func run(input: String) -> (Int?, Int?) {
		let lines: [[Cell]] = input.split(whereSeparator: \.isNewline).map(Array.init).map { chars in
			return chars.map { char in
				if char == "." {
					return Cell.open
				} else if char == "#" {
					return Cell.tree
				} else {
					print("Error!")
					return Cell.open
				}
			}
		}
		
		var sum = 1
		
		for (xSlope, ySlope) in [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)] {
			var y = 0
			var x = 0
			var trees = 0
			repeat {
				if lines[y][x % lines[y].count] == .tree {
					trees += 1
				}
				x += xSlope
				y += ySlope
			} while y < lines.count
			
			sum *= trees
		}
		
		return (nil, sum)
	}
	
}
