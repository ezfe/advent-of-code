//
//  2022 Day 15.swift
//  
//
//  Created by Ezekiel Elin on 12/14/22.
//

import Foundation

struct Day2022_15: Day {
	struct Coord: Equatable, Hashable {
		let x: Int
		let y: Int
		
		init(x: Int, y: Int) {
			self.x = x
			self.y = y
		}
		
		func distance(to other: Coord) -> Int {
			let xdiff = abs(self.x - other.x)
			let ydiff = abs(self.y - other.y)
			
			return xdiff + ydiff
		}
	}
	
	struct Reading {
		let sensor: Coord
		let beacon: Coord
		let distance: Int
		
		init(sensor: Coord, beacon: Coord) {
			self.sensor = sensor
			self.beacon = beacon
			self.distance = sensor.distance(to: beacon)
		}
		
		func generateEliminatedXCoordinates(row y: Int) -> Set<Int> {
			let distance = sensor.distance(to: beacon)
			
			let minX = sensor.x - Int(distance)
			let maxX = sensor.x + Int(distance)
			
			var set = Set<Int>()
			for x in minX...maxX {
				if sensor.distance(to: .init(x: x, y: y)) <= distance {
					set.insert(x)
				}
			}
			
			return set
		}
	}
	
	func run(input: String) async -> (Int?, Int?) {
		let regex = #/Sensor at x=(?<sensorX>-?[0-9]+), y=(?<sensorY>-?[0-9]+): closest beacon is at x=(?<beaconX>-?[0-9]+), y=(?<beaconY>-?[0-9]+)/#
		let readings = input.matches(of: regex).map { match in
			return Reading(sensor: Coord(x: match.sensorX.integer, y: match.sensorY.integer),
								beacon: Coord(x: match.beaconX.integer, y: match.beaconY.integer))
		}
		
		let part1Y = (readings[0].sensor.x > 100) ? 2000000 : 10
		var part1Cumulative = Set<Int>()
		for r in readings {
			part1Cumulative = part1Cumulative.union(r.generateEliminatedXCoordinates(row: part1Y))
		}
		
		let part1OverlappingSensors = readings.filter { $0.sensor.y == part1Y }.map(\.sensor.x)
		let part1OverlappingBeacons = readings.filter { $0.beacon.y == part1Y }.map(\.beacon.x)
		part1Cumulative = part1Cumulative.subtracting(part1OverlappingSensors)
		part1Cumulative = part1Cumulative.subtracting(part1OverlappingBeacons)

		let maxV = part1Y * 2
		var part2: Int?
		for x in 0...maxV {
			var y = 0
			while y <= maxV && part2 == nil {
				let coord = Coord(x: x, y: y)
				let sensorInRange = readings.first { $0.sensor.distance(to: coord) <= $0.distance }
				if let sensorInRange {
					let xdist = abs(sensorInRange.sensor.x - x)
					y = sensorInRange.sensor.y + sensorInRange.distance - xdist + 1
				} else {
					part2 = (coord.x  * 4000000) + coord.y
					break
				}
			}
		}

		return (part1Cumulative.count, part2)
	}
}
