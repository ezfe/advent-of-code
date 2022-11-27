//
//  File.swift
//
//
//  Created by Ezekiel Elin on 10/21/20.
//

import Foundation
import Algorithms

struct Day2019_7: Day {
	func run(input: String) {
		let program = input.filter { !$0.isWhitespace }.split(separator: ",").map { str in
			return Int(str)!
		}
		
		print(part1(program: program))
		print(part2(program: program))
	}
	
	func part1(program: [Int]) -> Int {
		var max = Int.min
		
		let parameters = [0,1,2,3,4]
		for permutation in parameters.permutations() {
			let result = evaluateSequence(program: program, sequence: permutation, part1: true)
			if result > max {
				max = result
			}
		}
		
		return max
	}
	
	func part2(program: [Int]) -> Int {
		var max = Int.min
		
		let parameters = [5,6,7,8,9]
		for permutation in parameters.permutations() {
			let result = evaluateSequence(program: program, sequence: permutation, part1: false)
			if result > max {
				max = result
			}
		}
		
		return max
	}
	
	func evaluateSequence(program: [Int], sequence: [Int], part1: Bool) -> Int {
		precondition(sequence.count == 5)
		
		let strLPBK = BufferedIO()
		let strA_B = BufferedIO()
		let strB_C = BufferedIO()
		let strC_D = BufferedIO()
		let strD_E = BufferedIO()
		
		strLPBK.write(sequence[0])
		strLPBK.write(0) // initial signal
		strA_B.write(sequence[1])
		strB_C.write(sequence[2])
		strC_D.write(sequence[3])
		strD_E.write(sequence[4])
		
		var ampA = IntcodeState(memory: program,
										input: strLPBK,
										output: strA_B)
		var ampB = IntcodeState(memory: program,
										input: strA_B,
										output: strB_C)
		var ampC = IntcodeState(memory: program,
										input: strB_C,
										output: strC_D)
		var ampD = IntcodeState(memory: program,
										input: strC_D,
										output: strD_E)
		var ampE = IntcodeState(memory: program,
										input: strD_E,
										output: strLPBK)
		
		while !ampE.halted {
			ampA = IntcodeState.advanceMulti(ampA)
			ampB = IntcodeState.advanceMulti(ampB)
			ampC = IntcodeState.advanceMulti(ampC)
			ampD = IntcodeState.advanceMulti(ampD)
			ampE = IntcodeState.advanceMulti(ampE)
			
			if part1 {
				break
			}
		}
		
		return strLPBK.read()!
	}
}
