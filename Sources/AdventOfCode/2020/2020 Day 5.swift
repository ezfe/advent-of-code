//
//  2020 Day 5.swift
//  
//
//  Created by Ezekiel Elin on 12/5/20.
//

import Foundation

struct Day2020_5: Day {
	func run(input: String) {
		let lines = input.split(whereSeparator: \.isNewline).map(String.init)
		let seatIDs = lines.map(alternative(instructions:))
		
		let max = seatIDs.max()!
		let min = seatIDs.min()!
		print(max)
		
		var mySeats = [Int]()
		for i in min...max {
			if !seatIDs.contains(i) && seatIDs.contains(i + 1) && seatIDs.contains(i - 1) {
				mySeats.append(i)
			}
		}
		print(mySeats.first!)
	}
	
	func alternative(instructions: String) -> Int {
		let binaryString = String(instructions.map {
			switch $0 {
				case "F", "L":
					return "0"
				default: // B, R
					return "1"
			}
		})
		return Int(binaryString, radix: 2)!
	}
}
