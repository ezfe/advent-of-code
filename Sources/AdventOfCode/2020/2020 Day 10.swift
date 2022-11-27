//
//  File.swift
//  
//
//  Created by Ezekiel Elin on 12/10/20.
//

import Foundation

struct Day2020_10: Day {
	func run(input: String) {
		let adapters = input.split(whereSeparator: \.isNewline).map { UInt8($0)! }.sorted()
		
		part1(adapters: adapters)
		part2(adapters: adapters)
	}
	
	func part2(adapters: [UInt8]) {
		let pattern = [0] + adapters + [adapters.last! + 3]
		var segments = [[UInt8]]()
		
		var working = [UInt8]()
		for i in 0..<pattern.count {
			working.append(pattern[i])
			if i < (pattern.count - 1) && pattern[i] + 3 == pattern[i + 1] {
				// only 1 path from i to i+1
				segments.append(working)
				working.removeAll()
				// re-add the same number after clearing list, since we need to connect the two segments
				working.append(pattern[i])
			}
		}
		
		let aset = Set(adapters)
		
		let fancy = segments.map {
			return routes(from: $0.first!,
							  to: $0.last!,
							  with: aset)
		}.reduce(1, *)
		print(fancy)
	}
	
	func routes(from: UInt8, to: UInt8, with adapters: Set<UInt8>) -> Int {
		var finished = Set<[UInt8]>()
		var working = Set([[from]]) // single starting point
		
		while !working.isEmpty {
			let way = working.popFirst()!
			
			let last = way.last!
			if last >= to {
				finished.insert(way)
				continue
			}
			
			let options = [last + 1, last + 2, last + 3]
			for opt in options where opt == to || (adapters.contains(opt) && opt <= to) {
				let newWay = way + [opt]
				working.insert(newWay)
			}
		}
		return finished.count
	}
	
	func part1(adapters: [UInt8]) {
		let devices = adapters + [adapters.last! + 3]
		
		var previous: UInt8 = 0
		
		var differences = [UInt8: Int]()
		devices.forEach { a in
			let diff = a - previous
			differences[diff] = (differences[diff] ?? 0) + 1
			previous = a
		}
		
		print(differences[1]! * differences[3]!)
	}
}
