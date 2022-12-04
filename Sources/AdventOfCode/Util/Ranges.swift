//
//  Ranges.swift
//  
//
//  Created by Ezekiel Elin on 12/4/22.
//

import Foundation

extension ClosedRange {
	func fullyContains(other range: ClosedRange) -> Bool {
		return self.contains(range.lowerBound) && self.contains(range.upperBound)
	}
}
