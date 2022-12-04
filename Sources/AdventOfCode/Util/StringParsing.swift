//
//  StringParsing.swift
//  
//
//  Created by Ezekiel Elin on 12/1/22.
//

import Foundation

extension StringProtocol {
	var integer: Int {
		return Int(self)!
	}

	var safeInteger: Int? {
		return Int(self)
	}
}
