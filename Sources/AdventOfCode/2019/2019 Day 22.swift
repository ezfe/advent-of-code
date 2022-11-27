//
//  Day 22.swift
//  
//
//  Created by Ezekiel Elin on 11/19/20.
//

import Foundation
import Algorithms

struct Day2019_22: Day {
	enum Shuffle {
		case dealNewStack
		case cut(Int)
		case dealIncrement(Int)
	}
	
	func run(input: String) {
		let lines = input.split(whereSeparator: \.isNewline)
		let actions = lines.map { line -> Shuffle in
			if line.starts(with: "c") {
				let nSubstring = line.dropFirst(4)
				let n = Int(nSubstring)!
				return .cut(n)
			} else if line.starts(with: "deal with") {
				let nSubstring = line.dropFirst(20)
				let n = Int(nSubstring)!
				return .dealIncrement(n)
			} else {
				return .dealNewStack
			}
		}
		
		let repeats = 1
		let M = 10007
		let startingIndex = 2019
		
		var i = startingIndex
		for _ in 0..<repeats {
			i = iteration(actions: actions, startingIndex: i, size: M)
		}
		print(i)
	}
	
	func iteration(actions: [Shuffle], startingIndex: Int, size: Int) -> Int {
		var i = startingIndex
		for action in actions {
			i = apply(shuffle: action, to: i, in: size)
		}
		return i
	}
	
	func apply(shuffle: Shuffle, to index: Int, in size: Int) -> Int {
		let value: Int
		switch shuffle {
			case .dealNewStack:
				value = size - 1 - index
			case .dealIncrement(let k):
				value = index * k
			case .cut(let s):
				value = index - s
		}
		if value < 0 {
			return (value % size) + size
		} else {
			return value % size;
		}
	}
}

