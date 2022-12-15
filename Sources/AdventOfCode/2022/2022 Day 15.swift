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
		
		func distance(to other: Coord) -> UInt {
			let xdiff = UInt(abs(self.x - other.x))
			let ydiff = UInt(abs(self.y - other.y))
			
			return xdiff + ydiff
		}
	}
	
	struct Reading {
		let sensor: Coord
		let beacon: Coord
		
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
		
		let y = 2000000
		let results = await concurrentPerform(input: readings) { r in
			return r.generateEliminatedXCoordinates(row: y)
		}
		var cumulative = Set<Int>()
		for result in results {
			cumulative = cumulative.union(result)
		}
		
		let overlappingSensors = readings.filter { $0.sensor.y == y }.map(\.sensor.x)
		let overlappingBeacons = readings.filter { $0.beacon.y == y }.map(\.beacon.x)
		cumulative = cumulative.subtracting(overlappingSensors)
		cumulative = cumulative.subtracting(overlappingBeacons)
		
		return (cumulative.count, nil)
	}
}
