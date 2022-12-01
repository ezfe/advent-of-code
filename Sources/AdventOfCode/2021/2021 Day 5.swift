//
//  2021 Day 4.swift
//  
//
//  Created by Ezekiel Elin on 12/1/20.
//

import Foundation
import RegexBuilder

struct Day2021_5: Day {
	struct Coordinate: Equatable, Hashable {
		let x: Int
		let y: Int
	}
	
	struct Line {
		let a: Coordinate
		let b: Coordinate
	}
	
	func run(input: String) {
		let startXRef = Reference(Int.self)
		let startYRef = Reference(Int.self)
		let endXRef = Reference(Int.self)
		let endYRef = Reference(Int.self)
		let lineRegex = Regex {
			TryCapture(as: startXRef) { OneOrMore(.digit) } transform: { Int($0) }
			","
			TryCapture(as: startYRef) { OneOrMore(.digit) } transform: { Int($0) }
			" -> "
			TryCapture(as: endXRef) { OneOrMore(.digit) } transform: { Int($0) }
			","
			TryCapture(as: endYRef) { OneOrMore(.digit) } transform: { Int($0) }
		}
		let lines = input.split(whereSeparator: \.isNewline)
			.map { lineText in
				let match = lineText.firstMatch(of: lineRegex)!
				let start = Coordinate(x: match[startXRef],
											  y: match[startYRef])
				let end = Coordinate(x: match[endXRef],
											y: match[endYRef])
				return Line(a: start, b: end)
			}
		
		part1(lines: lines, diagonalLineCheck: false)
		part1(lines: lines, diagonalLineCheck: true)
	}
	
	func part1(lines: [Line], diagonalLineCheck: Bool) {
		let horizontalLines = lines.filter { $0.a.y == $0.b.y }
		let verticalLines = lines.filter { $0.a.x == $0.b.x }
		
		let straightLines = horizontalLines + verticalLines
		let diagonalLines = lines.filter { $0.a.y != $0.b.y && $0.a.x != $0.b.x }

		let min: Coordinate
		let max: Coordinate
		do {
			let xPoints = lines
				.map { [$0.a.x, $0.b.x] }
				.reduce([], +)
			let yPoints = lines
				.map { [$0.a.y, $0.b.y] }
				.reduce([], +)
			
			min = Coordinate(x: xPoints.min()!, y: yPoints.min()!)
			max = Coordinate(x: xPoints.max()!, y: yPoints.max()!)
		}
		
		var qualifyingPoints = Set<Coordinate>()
		for x in min.x...max.x {
			for y in min.y...max.y {
				let qualifyingStraightLineCount = straightLines.filter { line in
					(
						(x >= line.a.x && x <= line.b.x)
						|| (x >= line.b.x && x <= line.a.x)
					) && (
						(y >= line.a.y && y <= line.b.y)
						|| (y >= line.b.y && y <= line.a.y)
					)
				}.count
				let qualifyingDiagonalLineCount = diagonalLines.filter { line in
					guard diagonalLineCheck else { return false }
					return (
						(
							(x >= line.a.x && x <= line.b.x)
							|| (x >= line.b.x && x <= line.a.x)
						) && (
							(y >= line.a.y && y <= line.b.y)
							|| (y >= line.b.y && y <= line.a.y)
						) && (
							((abs(line.a.y - y) == abs(line.a.x - x)) || (abs(line.b.y - y) == abs(line.b.x - x)))
						)
					)
				}.count
				let qualifyingLineCount = qualifyingStraightLineCount + qualifyingDiagonalLineCount
				if qualifyingLineCount >= 2 {
					qualifyingPoints.insert(Coordinate(x: x, y: y))
				}
			}
		}
		print(qualifyingPoints.count)
	}
}
