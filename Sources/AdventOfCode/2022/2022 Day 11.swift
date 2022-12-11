//
//  2022 Day 11.swift
//  
//
//  Created by Ezekiel Elin on 12/10/22.
//

import Foundation

struct Day2022_11: Day {
	struct Operation {
		enum Operand {
			case old
			case value(UInt)
			
			static func parse(source: Substring) -> Self {
				switch source {
					case "old":
						return .old
					default:
						return .value(UInt(source.integer))
				}
			}
		}
		
		enum Operator: Substring {
			case multiply = "*"
			case add = "+"
			
			func apply(lhs: UInt, rhs: UInt) -> UInt {
				switch self {
					case .multiply:
						return lhs * rhs
					case .add:
						return lhs + rhs
				}
			}
		}
		
		let lhs: Operand
		let rhs: Operand
		let op: Operator
		
		init(source: Substring) {
			let regex = #/(?<lhs>[a-z0-9]+) (?<op>[+*]) (?<rhs>[a-z0-9]+)/#
			let match = source.firstMatch(of: regex)!
			
			self.lhs = Operand.parse(source: match.lhs)
			self.rhs = Operand.parse(source: match.rhs)
			self.op = Operator(rawValue: match.op)!
		}
		
		func apply(old: UInt) -> UInt {
			let lhs: UInt
			let rhs: UInt
			
			switch self.lhs {
				case .old:
					lhs = old
				case .value(let v):
					lhs = v
			}
			
			switch self.rhs {
				case .old:
					rhs = old
				case .value(let v):
					rhs = v
			}
			
			return self.op.apply(lhs: lhs, rhs: rhs)
		}
	}

	struct Test {
		let divisor: UInt
		
		init(source: Substring) {
			if source.starts(with: "divisible by") {
				let v = source.dropFirst(13).integer
				self.divisor = UInt(v)
			} else {
				fatalError("Unexpected test: \(source)")
			}
		}
		
		func test(worry: UInt) -> Bool {
				return worry % divisor == 0
		}
		
		func reduce(worry: UInt) -> UInt {
			var worry = worry
			while worry > 10 * divisor {
				worry -= divisor
			}
			return worry
		}
	}

	struct Monkey: CustomStringConvertible {
		let id: Int
		var items: [UInt]
		let operation: Operation
		let test: Test
		let ifTrue: Int
		let ifFalse: Int

		init(monkeyId: Substring, startingItems: Substring, operation: Substring, test: Substring, ifTrue: Substring, ifFalse: Substring) {

			self.id = monkeyId.integer
			self.items = startingItems.split(separator: ", ").map(\.integer).map(UInt.init)
			self.operation = Operation(source: operation)
			self.test = Test(source: test)
			self.ifTrue = ifTrue.integer
			self.ifFalse = ifFalse.integer
		}
		
		var description: String {
			"Monkey{id:\(id),items:\(items)}"
		}
	}
	
	func run(input: String) async -> (Int?, Int?) {
		let regex = #/Monkey (?<monkeyId>[0-9]+):\n  Starting items: (?<startingItems>[0-9, ]+)\n  Operation: (?<operation>[a-z0-9 +*=]+)\n  Test: (?<test>[a-z0-9 ]+)\n    If true: throw to monkey (?<ifTrue>[0-9]+)\n    If false: throw to monkey (?<ifFalse>[0-9]+)\n/#
		let monkeyMatches = input.matches(of: regex)
		let monkeys = monkeyMatches.map { match in
			return Monkey(monkeyId: match.monkeyId, startingItems: match.startingItems, operation: match.operation, test: match.test, ifTrue: match.ifTrue, ifFalse: match.ifFalse)
		}
		
		return (run(monkeys: monkeys, part1: true),
				  run(monkeys: monkeys, part1: false))
	}
	
	func run(monkeys: [Monkey], part1: Bool) -> Int {
		var monkeys = monkeys
		var inspectionCounts = [Int: Int]()
		
		let part2Mod = monkeys.map(\.test.divisor).reduce(1, *)
		
		for _ in 1...(part1 ? 20 : 10000) {
			for mid in 0..<monkeys.count {
				while !monkeys[mid].items.isEmpty {
					var worry = monkeys[mid].items.removeFirst()
					worry = monkeys[mid].operation.apply(old: worry)
					if part1 {
						worry /= 3
					} else {
						worry %= part2Mod
					}
					let testResult = monkeys[mid].test.test(worry: worry)
					if testResult {
						monkeys[monkeys[mid].ifTrue].items.append(worry)
					} else {
						monkeys[monkeys[mid].ifFalse].items.append(worry)
					}
					inspectionCounts[mid, default: 0] += 1
				}
			}
		}
		
		let max = inspectionCounts.max(count: 2) { m1, m2 in
			return m1.value < m2.value
		}
		
		return max[0].value * max[1].value
	}
}
