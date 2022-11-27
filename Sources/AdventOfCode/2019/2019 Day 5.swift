//
//  File.swift
//  
//
//  Created by Ezekiel Elin on 10/20/20.
//

import Foundation

struct Day2019_5: Day {
	func run(input: String) {
		let program = input.filter { !$0.isWhitespace }.split(separator: ",").map { str in
			return Int(str)!
		}
		
		let computer1 = IntcodeState(memory: program,
											  input: PreloadedStream(stream: [1]))
		computer1.evaluate()
		
		let computer2 = IntcodeState(memory: program,
											  input: PreloadedStream(stream: [5]))
		computer2.evaluate()
	}
}
