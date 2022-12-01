//
//  Collections.swift
//  
//
//  Created by Ezekiel Elin on 12/1/22.
//

import Foundation

protocol NumericalIdentity {
	static var additionIdentity: Self {  get }
	static var multiplicationIdentity: Self {  get }
}

extension Int: NumericalIdentity {
	static var additionIdentity: Int { 0 }
	static var multiplicationIdentity: Int { 1 }
}

extension Double: NumericalIdentity {
	static var additionIdentity: Double { 0.0 }
	static var multiplicationIdentity: Double { 1 }
}

extension Sequence where Element: NumericalIdentity & AdditiveArithmetic {
	func sum() -> Element {
		return self.reduce(Element.additionIdentity, +)
	}
}
