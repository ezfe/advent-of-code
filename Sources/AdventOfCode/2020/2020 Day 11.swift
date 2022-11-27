//
//  2020 Day 11.swift
//  
//
//  Created by Ezekiel Elin on 12/10/20.
//

import Foundation

struct Day2020_11: Day {
	enum Cell: Character {
		case floor = "."
		case empty = "L"
		case occupied = "#"
	}
	
	func run(input: String) {
		let layout = input.split(whereSeparator: \.isNewline).map { line in
			return line.map { Cell.init(rawValue: $0)! }
		}
		
		
		// Part 1
		var current = layout
		while true {
			let new = step1(layout: current)
			if new == current {
				print(new.map { $0.filter { $0 == .occupied  }.count }.reduce(0, +))
				break
			}
			current = new
		}
		
		// Part 2
		current = layout
		while true {
			let new = step2(layout: current)
			if new == current {
				print(new.map { $0.filter { $0 == .occupied  }.count }.reduce(0, +))
				break
			}
			current = new
		}
	}
	
	func step1(layout: [[Cell]]) -> [[Cell]] {
		var new = layout
		for (y, row) in layout.enumerated() {
			for (x, space) in row.enumerated() {
				var surroundingCells = [Cell]()
				if y > 0 {
					let rowBefore = layout[y - 1]
					surroundingCells.append(contentsOf: rowBefore[max(x - 1, 0)...min(row.count - 1, x + 1)])
				}
				if x > 0 {
					surroundingCells.append(row[(x - 1)])
				}
				if x < row.count - 1 {
					surroundingCells.append(row[x + 1])
				}
				if y < layout.count - 1 {
					let rowAfter = layout[y + 1]
					surroundingCells.append(contentsOf: rowAfter[max(x - 1, 0)...min(row.count - 1, x + 1)])
				}
				let occupiedCount = surroundingCells.filter { $0 == .occupied }.count
				switch space {
					case .empty where occupiedCount == 0:
						new[y][x] = .occupied
					case .occupied where occupiedCount >= 4:
						new[y][x] = .empty
					default:
						break
				}
			}
		}
		return new
	}
	
	func step2(layout: [[Cell]]) -> [[Cell]] {
		var new = layout
		for (y, row) in layout.enumerated() {
			for (x, space) in row.enumerated() {
				let posX = findFirst(layout: layout, from: x, y, delta: 1, 0)
				let posXY = findFirst(layout: layout, from: x, y, delta: 1, 1)
				let posY = findFirst(layout: layout, from: x, y, delta: 0, 1)
				let posYnegX = findFirst(layout: layout, from: x, y, delta: -1, 1)
				let negX = findFirst(layout: layout, from: x, y, delta: -1, 0)
				let negXY = findFirst(layout: layout, from: x, y, delta: -1, -1)
				let negY = findFirst(layout: layout, from: x, y, delta: 0, -1)
				let posXnegY = findFirst(layout: layout, from: x, y, delta: 1, -1)
				
				let cells = [posX, posXY, posY, posYnegX, negX, negXY, negY, posXnegY]
				let occupiedCount = cells.compactMap { $0 }.filter { $0 == .occupied }.count
				
				switch space {
					case .empty where occupiedCount == 0:
						new[y][x] = .occupied
					case .occupied where occupiedCount >= 5:
						new[y][x] = .empty
					default:
						break
				}
			}
		}
		return new
	}
	
	func findFirst(layout: [[Cell]], from x: Int, _ y: Int, delta dx: Int, _ dy: Int) -> Cell? {
		var cx = x + dx
		var cy = y + dy
		while cx >= 0 && cy >= 0 && cx < layout[y].count && cy < layout.count {
			if layout[cy][cx] != .floor {
				return layout[cy][cx]
			} else {
				cx += dx
				cy += dy
			}
		}
		return nil
	}
	
	func printLayout(_ layout: [[Cell]]) {
		print("--------------")
		for row in layout {
			print(String(row.map { $0.rawValue }))
		}
	}
}
