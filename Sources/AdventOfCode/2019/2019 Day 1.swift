//
//  File.swift
//  
//
//  Created by Ezekiel Elin on 10/20/20.
//

import Foundation

struct Day2019_1: Day {
	func fuelFor(mass: Int) -> (Int, Int) {
		let calculated = mass / 3 - 2
		if calculated <= 0 {
			return (0, 0)
		}
		
		let (ra, rb) = fuelFor(mass: calculated)
		return (calculated, ra + rb)
	}
	
	func run(input: String) -> (Int?, Int?) {
		var part1 = 0
		var part2 = 0
		input.enumerateLines { (lineString, _) in
			let mass = Int(lineString) ?? 0
			let (fa, fb) = fuelFor(mass: mass)
			part1 += fa
			part2 += fa + fb
		}
		return (part1, part2)
	}
}
