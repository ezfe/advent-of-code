//
//  2020 Day 12.swift
//  
//
//  Created by Ezekiel Elin on 12/12/20.
//

import Foundation

struct Day2020_12: Day {
	enum Instruction {
		case north(Int)
		case south(Int)
		case east(Int)
		case west(Int)
		case left(Int)
		case right(Int)
		case forward(Int)
		
		static func parse<T: StringProtocol>(line: T) -> Self {
			let first = line.first!
			let number = Int(line.dropFirst())!
			switch first {
				case "N":
					return .north(number)
				case "S":
					return .south(number)
				case "E":
					return .east(number)
				case "W":
					return .west(number)
				case "L":
					return .left(number)
				case "R":
					return .right(number)
				case "F":
					return .forward(number)
				default:
					print("Can't parse direction: \(first)")
					exit(1)
			}
		}
	}
	
	func run(input: String) -> (Int?, Int?) {
		let layout = input.split(whereSeparator: \.isNewline).map { Instruction.parse(line: $0) }
		
		// north = 0°, +x
		// east = 90°, +z
		// south = 180°, -x
		// west = 270°, -z
		
		return (part1(layout: layout), part2(layout: layout))
	}
	
	func part1(layout: [Instruction]) -> Int {
		var x = 0
		var z = 0
		var direction = 90
		for ins in layout {
			switch ins {
				case .north(let dx):
					x += dx
				case .south(let ndx):
					x -= ndx
				case .east(let dz):
					z += dz
				case .west(let ndz):
					z -= ndz
				case .left(let ndd):
					direction = normalize(direction: direction - ndd)
				case .right(let dd):
					direction = normalize(direction: direction + dd)
				case .forward(let amnt):
					if direction == 0 {
						x += amnt
					} else if direction == 180 {
						x -= amnt
					} else if direction == 90 {
						z += amnt
					} else if direction == 270 {
						z -= amnt
					} else {
						print("How to handle \(direction)?")
						exit(2)
					}
			}
		}
		
		return abs(x) + abs(z)
	}
	
	func part2(layout: [Instruction]) -> Int {
		var wptdX = 1
		var wptdZ = 10
		var x = 0
		var z = 0
		
		for ins in layout {
			switch ins {
				case .north(let dx):
					wptdX += dx
				case .south(let ndx):
					wptdX -= ndx
				case .east(let dz):
					wptdZ += dz
				case .west(let ndz):
					wptdZ -= ndz
				case .left(let ndd):
					let (nx, nz) = rotate(point: wptdX, wptdZ, degrees: -ndd, around: x, z)
					wptdX = nx
					wptdZ = nz
				case .right(let dd):
					let (nx, nz) = rotate(point: wptdX, wptdZ, degrees: dd, around: x, z)
					wptdX = nx
					wptdZ = nz
				case .forward(let amnt):
					x += wptdX * amnt
					z += wptdZ * amnt
			}
		}
		
		return abs(x) + abs(z)
	}
	
	func normalize(direction: Int) -> Int {
		var direction = direction
		while direction < 0 {
			direction = 360 + direction // -90 + 360 = 270
		}
		direction %= 360
		return direction
	}
	
	func rotate(point x: Int, _ z: Int, degrees: Int, around cx: Int, _ cz: Int) -> (Int, Int) {
		var x = x
		var z = z
		var degrees = normalize(direction: degrees)
		
		// rotate around origin
		while degrees >= 90 {
			degrees -= 90
			// 90° rotation
			let nx = -z
			let nz = x
			x = nx
			z = nz
		}
		
		return (x, z)
	}
}
