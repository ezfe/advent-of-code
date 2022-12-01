//
//  2020 Day 13.swift
//
//
//  Created by Ezekiel Elin on 12/13/20.
//

import Foundation
import Atomics

struct Day2020_13: Day {
	func run(input: String) {
		let lines = input.split(whereSeparator: \.isNewline)
		
		part1(lines: lines)
		part2(lines: lines)
	}
	
	func part1<T: StringProtocol>(lines: [T]) {
		let earliestDeparture = Int(lines[0])!
		let routes = lines[1].split(separator: ",").compactMap { Int($0) }
		
		let (untilNextDeparture, selectedRoute) = routes.map { route in
			let sinceMostRecent = earliestDeparture % route
			let untilNextDeparture = route - sinceMostRecent
			
			return (untilNextDeparture, route)
		}.sorted { $0.0 < $1.0 }.first!
		
		print(selectedRoute * untilNextDeparture)
	}
	
	func part2<T: StringProtocol>(lines: [T]) {
		let routes = lines[1].split(separator: ",").map { rid in
			return Int(rid)
		}.enumerated().compactMap { (eseqel) -> (index: Int, route: Int)? in
			if let el = eseqel.element {
				return (index: eseqel.offset, route: el)
			} else {
				return nil
			}
		}.sorted { (i1, i2) -> Bool in
			i1.route > i2.route
		}
		
		let k = 100000000000000 / routes[0].route
		let queue = DispatchQueue(label: "processing-queue", qos: .userInitiated, attributes: .concurrent)
		
		// k
		let found = ManagedAtomic(Int.max)
		
		let group = DispatchGroup()
		let groups = 8
		for i in 0..<groups {
			group.enter()
			queue.async {
				part2Process(k: k + i, routes: routes)
				group.leave()
			}
		}
		
		group.wait()
		
		func part2Process(k: Int, routes: [(index: Int, route: Int)]) {
			var k = k
			while found.load(ordering: .relaxed) > k {
				let target = routes[0].route * k
				var failed = false
				for (i, route) in routes {
					if !(target + i).isMultiple(of: route) {
						failed = true
						break
					}
				}
				if failed {
					k += groups
				} else {
					found.store(k, ordering: .relaxed)
					print(routes[0].route * k)
					break
				}
			}
			print("Ended thread at \(k)")
		}
	}
}
