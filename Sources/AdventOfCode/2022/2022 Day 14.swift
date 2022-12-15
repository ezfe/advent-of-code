//
//  2022 Day 14.swift
//  
//
//  Created by Ezekiel Elin on 12/15/22.
//

import Foundation

struct Day2022_14: Day {
	struct Coord: Equatable, Hashable {
		let x: Int
		let y: Int
		
		var below: Coord {
			return Coord(x: x, y: y + 1)
		}

		var belowRight: Coord {
			return Coord(x: x + 1, y: y + 1)
		}
		
		var belowLeft: Coord {
			return Coord(x: x - 1, y: y + 1)
		}
	}

	struct Path: Equatable, Hashable {
		let a: Coord
		let b: Coord
		
		init(a: Coord, b: Coord) {
			if a.x != b.x && a.y != b.y {
				fatalError("Not a straight line: \(a) -> \(b)")
			}

			self.a = a
			self.b = b
		}
		
		func contains(coord: Coord) -> Bool {
			if coord.x == a.x && coord.x == b.x {
				return coord.y >= min(a.y, b.y) && coord.y <= max(a.y, b.y)
			} else if coord.y == a.y && coord.y == b.y {
				return coord.x >= min(a.x, b.x) && coord.x <= max(a.x, b.x)
			}
			return false
		}
	}

	func run(input: String) async -> (Int?, Int?) {
		let paths = input.split(whereSeparator: \.isNewline).map { line in
			let coords = line.split(separator: " -> ").map { (coord: Substring) in
				let split = coord.split(separator: ",")
				return Coord(x: split[0].integer, y: split[1].integer)
			}
			var paths = [Path]()
			for (i, coord) in coords.dropLast().enumerated() {
				paths.append(Path(a: coord, b: coords[i + 1]))
			}
			return paths
		}.reduce(Set<Path>()) { partialResult, path in
			return partialResult.union(path)
		}
		let abyss = paths.map { max($0.a.y, $0.b.y) }.max()! + 1
		
		let source = Coord(x: 500, y: 0)
		var sand = Set<Coord>()
		while let dest = propagate(from: source, existing: sand, paths: paths, abyss: abyss) {
			sand.insert(dest)
		}

		return (sand.count, nil)
	}
	
	func propagate(from source: Coord, existing sand: Set<Coord>, paths: Set<Path>, abyss: Int) -> Coord? {
		var loc = source
		
		while loc.y < abyss {
			if isFree(target: loc.below, sand: sand, paths: paths) {
				loc = loc.below
			} else if isFree(target: loc.belowLeft, sand: sand, paths: paths) {
				loc = loc.belowLeft
			} else if isFree(target: loc.belowRight, sand: sand, paths: paths) {
				loc = loc.belowRight
			} else {
				return loc
			}
		}
		return nil
	}
	
	func isFree(target: Coord, sand: Set<Coord>, paths: Set<Path>) -> Bool {
		if sand.contains(target) {
			return false
		}
		for path in paths {
			if path.contains(coord: target) {
				return false
			}
		}
		return true
	}
}
