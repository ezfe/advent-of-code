//
//  2021 Day 8.swift
//  
//
//  Created by Ezekiel Elin on 11/29/22.
//

import Foundation

struct Day2021_8: Day {
	struct Line {
		let samples: [Substring.SubSequence]
		let display: [Substring.SubSequence]
	}
	
	func run(input: String) -> (Int?, Int?) {
		let lines = input.split(whereSeparator: \.isNewline).map { line in
			let lineParsed = line.split(separator: " | ").map { linePart in
				linePart.split(whereSeparator: \.isWhitespace)
			}
			return Line(samples: lineParsed[0], display: lineParsed[1])
		}
		
		let part1Result = lines.map { line in
			line.display.filter { segment in
				segment.count == 2 || segment.count == 3 || segment.count == 4 || segment.count == 7
			}.count
		}.reduce(0, +)
		return (part1Result, nil)
	}
}
