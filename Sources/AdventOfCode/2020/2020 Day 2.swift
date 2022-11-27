//
//  2020 Day 2.swift
//  
//
//  Created by Ezekiel Elin on 12/2/20.
//

import Foundation

struct Day2020_2: Day {
	func run(input: String) {
		let lines = input.split(whereSeparator: \.isNewline)
		
		let passwords = lines.map { l -> PasswordInfo in
			let split = l.split(separator: ":")
			let password = String(split[1].dropFirst())
			let subsplit = split[0].split(separator: " ")
			let targetChar = subsplit[1].first!
			let range = subsplit[0].split(separator: "-")
			let rangeLow = Int(range[0])!
			let rangeHigh = Int(range[1])!
			
			return PasswordInfo(password: password,
									  char: targetChar,
									  first: rangeLow,
									  second: rangeHigh)
		}
		
		part1(passwords: passwords)
		part2(passwords: passwords)
	}
	
	struct PasswordInfo {
		let password: String
		let char: Character
		let first: Int
		let second: Int
	}
	
	func part1(passwords: [PasswordInfo]) {
		let count = passwords.filter { info in
			let foundCount = info.password.filter { $0 == info.char }.count
			return foundCount >= info.first && foundCount <= info.second
		}.count
		print(count)
	}
	
	func part2(passwords: [PasswordInfo]) {
		let count = passwords.filter { info in
			let chars = Array(info.password)
			let i1pass = chars[info.first - 1] == info.char
			let i2pass = chars[info.second - 1] == info.char
			return (i1pass && !i2pass) || (i2pass && !i1pass)
		}.count
		print(count)
	}
}
