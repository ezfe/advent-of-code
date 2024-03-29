//
//  2022 Day 2.swift
//  
//
//  Created by Ezekiel Elin on 12/1/22.
//

struct Day2022_2: Day {
	func run(input: String) -> (Int?, Int?) {
		let lines = input.split(whereSeparator: \.isNewline).map { line in
			line.split(whereSeparator: \.isWhitespace)
		}
		
		return (part1(lines: lines), part2(lines: lines))
	}
	
	func part1(lines: [[Substring.SubSequence]]) -> Int {
		var score = 0
		for line in lines {
			if line[1] == "X" {
				score += 1
			} else if line[1] == "Y" {
				score += 2
			} else if line[1] == "Z" {
				score += 3
			} else {
				assertionFailure()
			}

			if line[0] == "A" {
				if line[1] == "Y" {
					score += 6
				} else if line[1] == "X" {
					score += 3
				}
			} else if line[0] == "B" {
				if line[1] == "Z" {
					score += 6
				} else if line[1] == "Y" {
					score += 3
				}
			} else if line[0] == "C" {
				if line[1] == "X" {
					score += 6
				} else if line[1] == "Z" {
					score += 3
				}
			}
		}
		
		return score
	}

	func part2(lines: [[Substring.SubSequence]]) -> Int {
		var score = 0
		for line in lines {
			if line[1] == "Y" {
				score += 3
			} else if line[1] == "Z" {
				score += 6
			}

			if line[0] == "A" {
				if line[1] == "X" {
					score += 3
				} else if line[1] == "Y" {
					score += 1
				} else if line[1] == "Z" {
					score += 2
				}
			} else if line[0] == "B" {
				if line[1] == "X" {
					score += 1
				} else if line[1] == "Y" {
					score += 2
				} else if line[1] == "Z" {
					score += 3
				}
			} else if line[0] == "C" {
				if line[1] == "X" {
					score += 2
				} else if line[1] == "Y" {
					score += 3
				} else if line[1] == "Z" {
					score += 1
				}
			}
		}
		
		return score
	}
}
