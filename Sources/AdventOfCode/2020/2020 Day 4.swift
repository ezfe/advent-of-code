//
//  2020 Day 4.swift
//  
//
//  Created by Ezekiel Elin on 12/4/20.
//

import Foundation

struct Day2020_4: Day {
	func run(input: String) -> (Int?, Int?) {
		let tokens = input.split(omittingEmptySubsequences: false, whereSeparator: \.isWhitespace)
		
		let passports = tokens.split(whereSeparator: { $0.isEmpty })
		
		return(run(passports: passports, part2: false), run(passports: passports, part2: true))
	}
	
	func run(passports: [Array<String.SubSequence>.SubSequence], part2: Bool) -> Int {
		var pass = 0
		for passport in passports {
			var found = Set<Substring.SubSequence>()
			
		keyloop: for kvpair in passport {
			let split = kvpair.split(separator: ":")
			let key = split[0]
			
			if part2 {
				let value = split[1]
				
				switch key {
					case "byr":
						if !isNumber(str: value, min: 1920, max: 2002) {
							continue keyloop
						}
					case "iyr":
						if !isNumber(str: value, min: 2010, max: 2020) {
							continue keyloop
						}
					case "eyr":
						if !isNumber(str: value, min: 2020, max: 2030) {
							continue keyloop
						}
					case "hgt":
						guard let splitIndex = value.firstIndex(where: \.isLetter) else {
							continue keyloop
						}
						let numString = value[..<splitIndex]
						let units = value[splitIndex...]
						switch units {
							case "in":
								if !isNumber(str: numString, min: 59, max: 76) {
									continue keyloop
								}
							case "cm":
								if !isNumber(str: numString, min: 150, max: 193) {
									continue keyloop
								}
							default:
								continue keyloop
						}
					case "hcl":
						guard value.first == "#" else {
							continue keyloop
						}
						let rest = value.dropFirst()
						let nonMatchFound = rest.contains { char in
							return !(char.isNumber || ["a", "b", "c", "d", "e", "f"].contains(char))
						}
						if nonMatchFound || rest.count != 6 {
							continue keyloop
						}
					case "ecl":
						if !["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(value) {
							continue keyloop
						}
					case "pid":
						if value.count != 9 {
							continue keyloop
						}
						if value.contains(where: { !$0.isNumber }) {
							continue keyloop
						}
					default:
						break
				}
			}
			
			found.insert(key)
		}
			
			if found.count == 8 {
				pass += 1
			} else if found.count == 7 && !found.contains("cid") {
				pass += 1
			} else {
				// fail
			}
		}
		
		return pass
	}
	
	func isNumber(str: Substring.SubSequence, min: Int, max: Int) -> Bool {
		guard let int = Int(str) else {
			return false
		}
		return int >= min && int <= max
	}
}
