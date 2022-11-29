//
//  2021 Day 6.swift
//  
//
//  Created by Ezekiel Elin on 12/1/20.
//

import Foundation
import RegexBuilder

struct Day2021_6: Day {
	func run(input: String) {
		let agesList = input.split(separator: ",").map { Int($0)! }
		var ages = [Int: Int]()
		for age in agesList {
			ages[age, default: 0] += 1
		}

		for i in 1...256 {
			ages = pass(ages: ages)
			if i == 80 || i == 256 {
				print("Day \(i): \(ages.values.reduce(0, +))")
			}
		}
	}
	
	func pass(ages originalFish: [Int: Int]) -> [Int: Int] {
		var newFish = 0
		var existingFish = [Int: Int]()
		
		for (fish, qty) in originalFish {
			assert(fish >= 0, "Fish is negative!")
			assert(qty > 0, "Quantity is zero!")
			if fish == 0 {
				existingFish[6, default: 0] += qty
				newFish += qty
			} else {
				existingFish[fish - 1, default: 0] += qty
			}
		}
		
		if newFish > 0 {
			existingFish[8, default: 0] += newFish
		}
		return existingFish
	}
}