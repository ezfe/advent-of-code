//
//  2021 Day 4.swift
//  
//
//  Created by Ezekiel Elin on 12/1/20.
//

import Foundation

struct Day2021_4: Day {
	enum BingoCell: CustomStringConvertible {
		case unpicked(UInt)
		case picked(UInt)
		
		var description: String {
			switch self {
				case .picked(let v):
					return "\t*\(v)"
				case .unpicked(let v):
					return "\t\(v)"
			}
		}
	}

	struct BingoBoard: CustomStringConvertible {
		let rows: [[BingoCell]]
		
		func pick(number: UInt) -> Self {
			let newRows = rows.map { row in
				row.map { cell in
					switch cell {
						case .unpicked(let cellValue) where cellValue == number:
							return BingoCell.picked(cellValue)
						default:
							return cell
					}
				}
			}
			return BingoBoard(rows: newRows)
		}
		
		var isWinning: Bool {
			for i in 0..<rows.count {
				if check(row: i) {
					return true
				}
			}
			for i in 0..<rows[0].count {
				if check(column: i) {
					return true
				}
			}
			return false
		}
		
		func check(row rowIndex: Int) -> Bool {
			for cell in self.rows[rowIndex] {
				switch cell {
					case .picked(_):
						continue
					default:
						return false
				}
			}
			return true
		}
		
		func check(column colIndex: Int) -> Bool {
			for rowIndex in 0..<self.rows.count {
				let cell = self.rows[rowIndex][colIndex]
				switch cell {
					case .picked(_):
						continue
					default:
						return false
				}
			}
			return true
		}
		
		func unpickedSum() -> UInt {
			var sum: UInt = 0
			for row in self.rows {
				for cell in row {
					switch cell {
						case .unpicked(let value):
							sum += value
						default:
							continue
					}
				}
			}
			return sum
		}
		
		var description: String {
			return rows.map { row in
				row.map { $0.description }.joined()
			}.joined(separator: "\n")
		}
	}
	
	func run(input: String) -> (Int?, Int?) {
		let lines = input.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)
		let numbers = lines[0].split(separator: ",").map { UInt($0)! }
		let boardCount = Int(Double(lines.count - 1) / 6)
		assert(boardCount > 0)
		
		var boards = [BingoBoard]()
		for i in 0..<boardCount {
			let startRow = i * 6 + 2
			let endRow = startRow + 5
			
			var rows = [[BingoCell]]()
			for rowIndex in startRow..<endRow {
				let row = lines[rowIndex].split(whereSeparator: \.isWhitespace).map { BingoCell.unpicked(UInt($0)!) }
				rows.append(row)
			}
			boards.append(BingoBoard(rows: rows))
		}
		
		return (part1(numbers: numbers, boards: boards), part2(numbers: numbers, boards: boards))
	}
	
	func part1(numbers: [UInt], boards: [BingoBoard]) -> Int? {
		var boards = boards
		for pick in numbers {
			boards = boards.map { $0.pick(number: pick) }
			let winningBoard = boards.first { $0.isWinning }
			if let winningBoard {
				let sum = winningBoard.unpickedSum()
				let result = sum * pick
				print("unpicked sum: \(sum); pick: \(pick)")
				return Int(result)
			}
		}
		return nil
	}
	
	func part2(numbers: [UInt], boards: [BingoBoard]) -> Int? {
		var boards = boards
		for pick in numbers {
			boards = boards.map { $0.pick(number: pick) }
			let resultingBoards = boards.filter { !$0.isWinning }
			if resultingBoards.isEmpty {
				let losingBoard = boards[0]
				let sum = losingBoard.unpickedSum()
				let result = sum * pick
				print("unpicked sum: \(sum); pick: \(pick)")
				return Int(result)
			}
			boards = resultingBoards
		}
		return nil
	}
}
