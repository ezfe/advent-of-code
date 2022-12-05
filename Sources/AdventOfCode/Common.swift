//
//  Common.swift
//  
//
//  Created by Ezekiel Elin on 11/27/22.
//

import Foundation

protocol Day {
	associatedtype ReturnType: Equatable
	func run(input: String) async -> (ReturnType?, ReturnType?)
}

protocol EntryPoints {
	var entryPoints: [Int: any Day] { get }
}
