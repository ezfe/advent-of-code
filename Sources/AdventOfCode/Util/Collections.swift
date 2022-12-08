//
//  Collections.swift
//  
//
//  Created by Ezekiel Elin on 12/1/22.
//

import Foundation

extension Collection<Int> {
	func sum() -> Element {
		return self.reduce(0, +)
	}
}

extension Collection<UInt64> {
	func sum() -> Element {
		return self.reduce(0, +)
	}
}

extension Array where Element: FloatingPoint {
	func sum() -> Element {
		return self.reduce(0, +)
	}
	
	func average() -> Element {
		return self.sum() / Element(self.count)
	}
	
	func standardDeviation() -> Element {
		let mean = self.average()
		let v = self.reduce(0, { $0 + ($1-mean)*($1-mean) })
		return sqrt(v / (Element(self.count) - 1))
	}
}
