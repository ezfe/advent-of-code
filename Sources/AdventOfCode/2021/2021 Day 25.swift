//
//  2021 Day 25.swift
//  
//
//  Created by Ezekiel Elin on 11/29/22.
//

import Foundation
import RegexBuilder

struct Day2021_25: Day {
	struct Board: CustomStringConvertible, Equatable {
		let width: Int
		let height: Int
		
		var rows = [[Cell]]()
		
		init(input: String) {
			let lines = input.split(whereSeparator: \.isNewline).map { line in
				line.map { Cell(rawValue: $0)! }
			}
			
			self.rows = lines
			
			self.height = lines.count
			self.width = lines[0].count
			lines.forEach { assert($0.count == self.width, "Board isn't square") }
		}
		
		var description: String {
			return self.rows
				.map { row in
					row.map { $0.description }.joined()
				}
				.joined(separator: "\n")
		}
		
		func step(direction: Direction) -> Board {
			var newBoard = self
			for x in 0..<width {
				for y in 0..<height {
					guard direction.shouldMove(cell: self.rows[y][x]) else {
						continue
					}
					let targetX = (x + direction.deltaX) % width
					let targetY = (y + direction.deltaY) % height
					if case .empty = self.rows[targetY][targetX] {
						newBoard.rows[y][x] = .empty
						newBoard.rows[targetY][targetX] = self.rows[y][x]
					}
				}
			}
			return newBoard
		}
		
		static func ==(lhs: Board, rhs: Board) -> Bool {
			return lhs.rows == rhs.rows
		}
		
		enum Direction {
			case east
			case south
			
			var deltaX: Int {
				switch self {
					case .east:
						return 1
					case .south:
						return 0
				}
			}
			
			var deltaY: Int {
				switch self {
					case .east:
						return 0
					case .south:
						return 1
				}
			}
			
			func shouldMove(cell: Cell) -> Bool {
				switch cell {
					case .east:
						return self == .east
					case .south:
						return self == .south
					case .empty:
						return false
				}
			}
		}
		
		enum Cell: Character, CustomStringConvertible {
			case empty = "."
			case east = ">"
			case south = "v"
			
			var description: String { return "\(self.rawValue)" }
		}
	}
	
	func run(input: String) {
		var board = Board(input: input)
		var i = 0
		while true {
			var newBoard = board
			newBoard = newBoard.step(direction: .east)
			newBoard = newBoard.step(direction: .south)
			i += 1
			if newBoard == board {
				break
			} else {
				board = newBoard
			}
		}
		print(i)
	}
}
