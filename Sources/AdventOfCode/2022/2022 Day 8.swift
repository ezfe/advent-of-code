//
//  File.swift
//  
//
//  Created by Ezekiel Elin on 12/8/22.
//

import Foundation

struct Day2022_8: Day {
	enum Visibility: CustomStringConvertible {
		case yes, no
		
		var description: String {
			switch self {
				case .no:
					return "N"
				case .yes:
					return "Y"
			}
		}
	}
	
	struct TreeVisibility: CustomStringConvertible {
		var left: Visibility?
		var right: Visibility?
		var top: Visibility?
		var bottom: Visibility?
		
		var description: String {
			let leftStr: String
			if let left {
				leftStr = left.description
			} else {
				leftStr = "?"
			}
			
			let rightStr: String
			if let right {
				rightStr = right.description
			} else {
				rightStr = "?"
			}
			
			let topStr: String
			if let top {
				topStr = top.description
			} else {
				topStr = "?"
			}
			
			let bottomStr: String
			if let bottom {
				bottomStr = bottom.description
			} else {
				bottomStr = "?"
			}
			
			return "{L:\(leftStr),R:\(rightStr),T:\(topStr),B:\(bottomStr)}"
		}
	}
	
	func run(input: String) async -> (Int?, Int?) {
		let grid = input.split(whereSeparator: \.isNewline).map { Array($0).map { $0.wholeNumberValue! } }
		
		return (part1(grid: grid), part2(grid: grid))
	}
	
	func part1(grid: [[Int]]) -> Int {
		var visibility = [[TreeVisibility]]()

		for row in grid {
			var rowVisibility = [TreeVisibility]()
			var max = Int.min
			for height in row {
				if height > max {
					max = height
					rowVisibility.append(TreeVisibility(left: .yes))
				} else {
					rowVisibility.append(TreeVisibility(left: .no))
				}
			}
			visibility.append(rowVisibility)
		}
		
		for (rowIdx, row) in grid.enumerated() {
			var max = Int.min
			for (colIdx, height) in row.enumerated().reversed() {
				if height > max {
					max = height
					visibility[rowIdx][colIdx].right = .yes
				} else {
					visibility[rowIdx][colIdx].right = .no
				}
			}
		}
		
		for colIdx in 0..<grid[0].count {
			var max = Int.min
			for rowIdx in 0..<grid.count {
				let height = grid[rowIdx][colIdx]
				if height > max {
					max = height
					visibility[rowIdx][colIdx].top = .yes
				} else {
					visibility[rowIdx][colIdx].top = .no
				}
			}
		}
		
		for colIdx in 0..<grid[0].count {
			var max = Int.min
			for rowIdx in (0..<grid.count).reversed() {
				let height = grid[rowIdx][colIdx]
				if height > max {
					max = height
					visibility[rowIdx][colIdx].bottom = .yes
				} else {
					visibility[rowIdx][colIdx].bottom = .no
				}
			}
		}
		
		let visible = visibility.reduce([], +).filter { (v: TreeVisibility) in
			return v.right == .yes || v.left == .yes || v.top == .yes || v.bottom == .yes
		}.count
		
		return visible
	}
	
	func part2(grid: [[Int]]) -> Int {
		let scores = grid.enumerated().map { (i, row) in
			return row.enumerated().map { (j, _) in
				score(i: i, j: j, grid: grid)
			}
		}
		
		let allScores = scores.reduce([], +)
		let max = allScores.max { (lhs: (Int, Int, Int, Int), rhs: (Int, Int, Int, Int)) in
			(lhs.0 * lhs.1 * lhs.2 * lhs.3) < (rhs.0 * rhs.1 * rhs.2 * rhs.3)
		}!
		
		return max.0 * max.1 * max.2 * max.3
	}
	
	func score(i: Int, j: Int, grid: [[Int]]) -> (Int, Int, Int, Int) {
		var up = 0
		for ii in (0..<i).reversed() {
			up += 1
			
			if grid[ii][j] >= grid[i][j] {
				break
			}
		}
		
		var down = 0
		for ii in ((i+1)..<grid.count) {
			down += 1
			
			if grid[ii][j] >= grid[i][j] {
				break
			}
		}
		
		var right = 0
		for jj in ((j+1)..<grid[0].count) {
			right += 1
			
			if grid[i][jj] >= grid[i][j] {
				break
			}
		}
		
		var left = 0
		for jj in (0..<j).reversed() {
			left += 1
			
			if grid[i][jj] >= grid[i][j] {
				break
			}
		}
		
		return (up, down, left, right)
	}
}
