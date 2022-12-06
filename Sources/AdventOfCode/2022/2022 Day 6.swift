//
//  2022 Day 6.swift
//  
//
//  Created by Ezekiel Elin on 12/5/22.
//

import Foundation

struct Day2022_6: Day {
	func run(input: String) async -> (Int?, Int?) {
		let input = Array(input)
		return (detect(input: input, width: 4), detect(input: input, width: 14))
	}
	
	func detect(input: [Character], width: Int) -> Int {
		for i in (width - 1)..<input.count {
			let chars = Set(input[(i - width + 1)...i])
			if chars.count == width {
				return i + 1
			}
		}
		return -1
	}
}
