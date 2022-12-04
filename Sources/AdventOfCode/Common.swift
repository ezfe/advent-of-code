//
//  Common.swift
//  
//
//  Created by Ezekiel Elin on 11/27/22.
//

import Foundation

protocol Day {
	func run(input: String) async -> (Int?, Int?)
}

protocol EntryPoints {
	var entryPoints: [Int: Day] { get }
}
