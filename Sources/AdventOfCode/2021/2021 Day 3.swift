//
//  2020 Day 1.swift
//  
//
//  Created by Ezekiel Elin on 12/1/20.
//

import Foundation

struct Day2021_3: Day {
	
	let len = 12
	
	func run(input: String) {
		let lines_txt = input.split(whereSeparator: \.isNewline)
		let lines = lines_txt.map { UInt16($0, radix: 2)! }
		
		let chars = UInt8(lines_txt.first!.count)
		
		part1(lines: lines, bitCount: chars)
		part2(lines: lines, bitCount: chars)
	}
	
	func gamma(lines: [UInt16]) -> UInt16 {
		var gamma: UInt16 = 0
		for i in 0..<len {
			let ones = lines
				.map { $0 >> (len - 1 - i) & 1 }
				.reduce(0, +)
			gamma <<= 1
			if ones >= (UInt16(lines.count) - ones) {
				gamma |= 1
			}
		}
		return gamma
	}
	
	func epsilon(gamma: UInt16, bitCount: UInt8) -> UInt16 {
		let bitmask = UInt16(pow(2.0, Double(bitCount)) - 1)
		return ~gamma & bitmask
	}
	
	func part1(lines: [UInt16], bitCount: UInt8) {
		let gamma = gamma(lines: lines)
		let epsilon = epsilon(gamma: gamma, bitCount: bitCount)
		print("gamma: \(gamma); epsilon: \(epsilon)")
		print(UInt32(gamma) * UInt32(epsilon))
	}
	
	func part2(lines: [UInt16], bitCount: UInt8) {
		var searchBit = UInt16(pow(2, Double(bitCount - 1)))
		
		var oxygenNumbers = lines
		while oxygenNumbers.count > 1 {
			let gamma = gamma(lines: oxygenNumbers)
			let newNumbers = oxygenNumbers.filter {
				($0 & searchBit) == (gamma & searchBit)
			}
			if newNumbers.isEmpty {
				assertionFailure("Filtered out all the numbers!")
			} else {
				oxygenNumbers = newNumbers
			}
			searchBit >>= 1
		}
		
		searchBit = UInt16(pow(2, Double(bitCount - 1)))
		
		var co2Numbers = lines
		while co2Numbers.count > 1 {
			let gamma = epsilon(gamma: gamma(lines: co2Numbers), bitCount: bitCount)
			let newNumbers = co2Numbers.filter {
				($0 & searchBit) == (gamma & searchBit)
			}
			if newNumbers.isEmpty {
				assertionFailure("Filtered out all the numbers!")
			} else {
				co2Numbers = newNumbers
			}
			searchBit >>= 1
		}
		
		print("O2: \(oxygenNumbers[0]); CO2: \(co2Numbers[0])")
		print(UInt32(oxygenNumbers[0]) * UInt32(co2Numbers[0]))
	}
}
