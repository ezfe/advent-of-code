//
//  2022 Day 18.swift
//  
//
//  Created by Ezekiel Elin on 12/17/22.
//

import Foundation

struct Day2022_18: Day {
	struct Coord: Equatable, Hashable, CustomStringConvertible {
		let x: Int
		let y: Int
		let z: Int
		
		var description: String {
			"{\(x),\(y),\(z)}"
		}
	}
	func run(input: String) async -> (Int?, Int?) {
		let cubes = input.split(whereSeparator: \.isNewline).map { line in
			let components = line.split(separator: ",")
			return Coord(x: components[0].integer, y: components[1].integer, z: components[2].integer)
		}
		
		return (part1(cubes: cubes), part2(cubes: cubes))
	}
	
	func part1(cubes: [Coord]) -> Int {
		var store = [Coord: Bool]()
		cubes.forEach { coord in
			store[coord] = true
		}

		var surfaceArea = 0
		for cube in cubes {
			if store[Coord(x: cube.x, y: cube.y, z: cube.z + 1), default: false] == false {
				surfaceArea += 1
			}
			if store[Coord(x: cube.x, y: cube.y, z: cube.z - 1), default: false] == false {
				surfaceArea += 1
			}
			if store[Coord(x: cube.x, y: cube.y + 1, z: cube.z), default: false] == false {
				surfaceArea += 1
			}
			if store[Coord(x: cube.x, y: cube.y - 1, z: cube.z), default: false] == false {
				surfaceArea += 1
			}
			if store[Coord(x: cube.x + 1, y: cube.y, z: cube.z), default: false] == false {
				surfaceArea += 1
			}
			if store[Coord(x: cube.x - 1, y: cube.y, z: cube.z), default: false] == false {
				surfaceArea += 1
			}
		}

		return surfaceArea
	}
	
	func part2(cubes: [Coord]) -> Int {
		var store = [Coord: Bool]()
		cubes.forEach { coord in
			store[coord] = true
		}
		
		var queue = [Coord(x: 0, y: 0, z: 0)]
		while !queue.isEmpty {
			expand(from: queue.removeLast(), on: &store, with: &queue)
		}

		var surfaceArea = 0
		for cube in cubes {
			if store[Coord(x: cube.x, y: cube.y, z: cube.z + 1)] == false {
				surfaceArea += 1
			}
			if store[Coord(x: cube.x, y: cube.y, z: cube.z - 1)] == false {
				surfaceArea += 1
			}
			if store[Coord(x: cube.x, y: cube.y + 1, z: cube.z)] == false {
				surfaceArea += 1
			}
			if store[Coord(x: cube.x, y: cube.y - 1, z: cube.z)] == false {
				surfaceArea += 1
			}
			if store[Coord(x: cube.x + 1, y: cube.y, z: cube.z)] == false {
				surfaceArea += 1
			}
			if store[Coord(x: cube.x - 1, y: cube.y, z: cube.z)] == false {
				surfaceArea += 1
			}
		}

		return surfaceArea
	}
	
	func expand(from: Coord, on store: inout [Coord: Bool], with queue: inout [Coord]) {
		guard -2...25 ~= from.x else { return }
		guard -2...25 ~= from.y else { return }
		guard -2...25 ~= from.z else { return }
		if store[Coord(x: from.x, y: from.y, z: from.z + 1)] == nil {
			queue.append(Coord(x: from.x, y: from.y, z: from.z + 1))
			store[Coord(x: from.x, y: from.y, z: from.z + 1)] = false
		}
		if store[Coord(x: from.x, y: from.y, z: from.z - 1)] == nil {
			queue.append(Coord(x: from.x, y: from.y, z: from.z - 1))
			store[Coord(x: from.x, y: from.y, z: from.z - 1)] = false
		}
		if store[Coord(x: from.x, y: from.y + 1, z: from.z)] == nil {
			queue.append(Coord(x: from.x, y: from.y + 1, z: from.z))
			store[Coord(x: from.x, y: from.y + 1, z: from.z)] = false
		}
		if store[Coord(x: from.x, y: from.y - 1, z: from.z)] == nil {
			queue.append(Coord(x: from.x, y: from.y - 1, z: from.z))
			store[Coord(x: from.x, y: from.y - 1, z: from.z)] = false
		}
		if store[Coord(x: from.x + 1, y: from.y, z: from.z)] == nil {
			queue.append(Coord(x: from.x + 1, y: from.y, z: from.z))
			store[Coord(x: from.x + 1, y: from.y, z: from.z)] = false
		}
		if store[Coord(x: from.x - 1, y: from.y, z: from.z)] == nil {
			queue.append(Coord(x: from.x - 1, y: from.y, z: from.z))
			store[Coord(x: from.x - 1, y: from.y, z: from.z)] = false
		}
	}
}
