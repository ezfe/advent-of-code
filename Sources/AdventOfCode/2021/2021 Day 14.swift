//
//  2020 Day 14.swift
//  
//
//  Created by Ezekiel Elin on 12/14/20.
//

import Foundation

struct Day2021_14: Day {
    enum Value: Character {
        case A = "A"
        case B = "B"
        case C = "C"
        case D = "D"
        case E = "E"
        case F = "F"
        case G = "G"
        case H = "H"
        case I = "I"
        case J = "J"
        case K = "K"
        case L = "L"
        case M = "M"
        case N = "N"
        case O = "O"
        case P = "P"
        case Q = "Q"
        case R = "R"
        case S = "S"
        case T = "T"
        case U = "U"
        case V = "V"
        case W = "W"
        case X = "X"
        case Y = "Y"
        case Z = "Z"
    }
    struct Rule {
        let pair: Pair
        let insert: Value
    }
    struct Pair: Hashable {
        let first: Value
        let second: Value
    }

    func run(input: String) {
        let lines = input.split(whereSeparator: \.isNewline)
        
        let template = Array(lines[0]).compactMap(Value.init)
        let rulesList = lines[1...].map { ruleString -> Rule in
            let components = ruleString.components(separatedBy: " -> ")
            return Rule(
                pair: Pair(
                    first: Value(rawValue: components[0].first!)!,
                    second: Value(rawValue: components[0].last!)!
                ),
                insert: Value(rawValue: components[1].first!)!)
        }
        var _rules = Dictionary<Pair, Value>()
        for r in rulesList {
            _rules[r.pair] = r.insert
        }
        let rules = _rules
        
        let sem = DispatchSemaphore(value: 0)
        Task {
            let count = UInt(10)
            // async
            // let result = await chunkedIter(polymer: template, rules: rules, count: count)
            // sync
            // let result = await iter(polymer: template, rules: rules, count: count)
            // pairwise
            // let result = pairedIter(polymer: template, rules: rules, count: count)
                
            let uniques = Set(result)
            var counts = [Value:Int]()
            for u in uniques {
                counts[u] = result.filter { $0 == u }.count
            }
            let min = counts.min { $0.value < $1.value }
            let max = counts.max { $0.value < $1.value }
            print(max!.value - min!.value)
            sem.signal()
        }
        sem.wait()
    }
    
    func pairedIter(polymer: [Value],
                    rules: Dictionary<Pair, Value>,
                    count: UInt) -> Dictionary<Pair, UInt> {

        var pairCounts = Dictionary<Pair, UInt>()
        for i in 0..<(polymer.count - 1) {
            let pair = Pair(first: polymer[i], second: polymer[i + 1])
            pairCounts[pair] = (pairCounts[pair] ?? 0) + 1
        }
        
        for _ in 0..<count {
            pairCounts = pairedSub(pairs: pairCounts, rules: rules)
        }
        
        return pairCounts
    }
    
    func pairedSub(pairs: Dictionary<Pair, UInt>, rules: Dictionary<Pair, Value>) -> Dictionary<Pair, UInt> {
        var new = pairs
        
        for (pair, _) in pairs {
            if let insert = rules[pair] {
                let np1 = Pair(first: pair.first, second: insert)
                let np2 = Pair(first: insert, second: pair.second)
                new[pair] = (new[pair] ?? 0) - 1
                new[np1] = (new[np1] ?? 0) + 1
                new[np2] = (new[np2] ?? 0) + 1
            }
        }

        return new
    }

    func chunkedIter(polymer: [Value],
                     rules: Dictionary<Pair, Value>,
                     count: UInt) async -> [Value] {
        
        var start = 0
        let chunkSize = polymer.count / 8
        var chunkedTemplate = [Array<Value>.SubSequence]()
        while start < polymer.count {
            let chunk = polymer[start...min(start+chunkSize, polymer.count - 1)]
            chunkedTemplate.append(chunk)
            start += chunkSize
        }

        let iteratedChunks = try! await chunkedTemplate.parallelMap(parallelism: 8) { chunk in
            await iter(polymer: Array(chunk), rules: rules, count: count)
        }
        
        var iteratedResult = [Value]()
        for ic in iteratedChunks.dropLast() {
            iteratedResult.append(contentsOf: ic.dropLast())
        }
        iteratedResult.append(contentsOf: iteratedChunks.last!)
        
        return iteratedResult
    }

    func iter(polymer: [Value],
              rules: Dictionary<Pair, Value>,
              count: UInt) async -> [Value] {

        await withUnsafeContinuation { continuation in
            var polymer = polymer
            for _ in 0..<count {
                polymer = sub(polymer: polymer, rules: rules)
            }
            continuation.resume(returning: polymer)
        }
    }
    
    func sub(polymer: [Value],
             rules: Dictionary<Pair, Value>) -> [Value] {
        var new = [Value]()
        
        for i in 0..<(polymer.count - 1) {
            let pair = Pair(first: polymer[i], second: polymer[i + 1])
            
            new.append(pair.first)
            if let insert = rules[pair] {
                new.append(insert)
            }
        }
        new.append(polymer[polymer.count - 1])

        return new
    }
}

fileprivate extension Collection {
  func parallelMap<T>(
    parallelism requestedParallelism: Int? = nil,
    _ transform: @escaping (Element) async throws -> T
  ) async throws -> [T] {
    let defaultParallelism = 2
    let parallelism = requestedParallelism ?? defaultParallelism

    let n = self.count
    if n == 0 {
      return []
    }

    return try await withThrowingTaskGroup(of: (Int, T).self) { group in
      var result = Array<T?>(repeatElement(nil, count: n))

      var i = self.startIndex
      var submitted = 0

      func submitNext() async throws {
        if i == self.endIndex { return }

        group.addTask { [submitted, i] in
          let value = try await transform(self[i])
          return (submitted, value)
        }
        submitted += 1
        formIndex(after: &i)
      }

      // submit first initial tasks
      for _ in 0..<parallelism {
        try await submitNext()
      }

      // as each task completes, submit a new task until we run out of work
      while let (index, taskResult) = try! await group.next() {
        result[index] = taskResult

        try Task.checkCancellation()
        try await submitNext()
      }

      assert(result.count == n)
      return Array(result.compactMap { $0 })
    }
  }
}
