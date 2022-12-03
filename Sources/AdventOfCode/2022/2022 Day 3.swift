//
//  2022 Day 3.swift
//  
//
//  Created by Ezekiel Elin on 12/3/22.
//

import Foundation

struct Day2022_3: Day {
	func run(input: String) async {
		let sacks = input
			.split(whereSeparator: \.isNewline)
			.map { Array($0) }
		
		let part1 = sacks.map { sack in
			let cs = sack.count / 2
			  let c1 = sack[0..<cs]
			  let c2 = sack[cs...]
			  let common = c1.filter { c2.contains($0) }
			  return common.first!
		  }
		  .map(priority(char:))
		  .sum()
				
		let part2 = sacks
			.chunks(ofCount: 3)
			.map(badge(chunk:))
			.map(priority(char:))
			.sum()
		
		print(part1)
		print(part2)
	}
	
	func badge(chunk: ArraySlice<[Character]>) -> Character {
		let c1 = chunk[chunk.startIndex]
		let c2 = chunk[chunk.startIndex + 1]
		let c3 = chunk[chunk.startIndex + 2]
		let common = c1
			.filter { c2.contains($0) }
			.filter { c3.contains($0) }
		return common.first!
	}
	
	func priority(char: Character) -> Int {
		switch char {
			case "a"..."z":
				return Int(char.asciiValue!) - 96
			case "A"..."Z":
				return Int(char.asciiValue!) - 38
			default:
				assertionFailure("\(char) is out of range")
				return 0
		}
	}
}
