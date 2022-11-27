//
//  File.swift
//  
//
//  Created by Ezekiel Elin on 10/20/20.
//

import Foundation

struct Day2015_16: Day {
	let known = [
		"children": 3,
		"cats": 7, // >
		"samoyeds": 2,
		"pomeranians": 3, // <
		"akitas": 0,
		"vizslas": 0,
		"goldfish": 5,
		"trees": 3, // >
		"cars": 2,
		"perfumes": 1 // <
	]
	
	func run(input: String) {
		let auntInfo = input
			.split(whereSeparator: \.isNewline)
			.map { row in
				row[row.firstIndex(of: ":")!...].dropFirst().split(separator: ",")
			}
			.map { components -> [String: Int] in
				var info = [String: Int]()
				components.forEach { attribute in
					let parts = attribute.dropFirst().split(separator: ":")
					info[String(parts[0])] = Int(String(parts[1].dropFirst()))!
				}
				return info
			}
		
		let filtered = auntInfo.enumerated().filter { (_, info) in
			for (key, rememberedValue) in info {
				if let sensorValue = known[key] {
					/* Day 2 */
					if key == "cats" || key == "trees" {
						if rememberedValue <= sensorValue {
							return false
						}
					} else if key == "pomeranians" || key == "perfumes" {
						if rememberedValue >= sensorValue {
							return false
						}
					} else if rememberedValue != sensorValue {
						return false
					}
					/* Day 1 */
					/*
					 if rememberedValue != sensorValue {
					 return false
					 }
					 */
				}
			}
			print("No conflicting information")
			return true
		}.first!
		
		print(filtered.offset + 1)
	}
}
