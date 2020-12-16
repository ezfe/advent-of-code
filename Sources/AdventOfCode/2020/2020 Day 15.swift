//
//  2020 Day 15.swift
//  
//
//  Created by Ezekiel Elin on 12/15/20.
//

import Foundation

struct Day2020_15: Day {
    func run(input: String) {
        let starters = input
            .split(whereSeparator: \.isNewline)
            .first!
            .split(separator: ",")
            .map { Int($0)! }
        
        read(starters: starters, to: 2020)
        read(starters: starters, to: 30000000)
    }
    
    func read(starters: [Int], to: Int) {
        var last = 0
        var indexes = [Int: [Int]]() // value: indexes read at
        for (i, v) in starters.enumerated() {
            last = v
            indexes[v] = [i]
        }
        
        for i in starters.count..<to {
            let output: Int
            let prevReads = indexes[last]!
            if prevReads.count == 1 {
                output = 0
            } else {
                let diff = prevReads[prevReads.count - 1] - prevReads[prevReads.count - 2]
                output = diff
            }
            last = output
            if let newPrevReads = indexes[output] {
                indexes[output] = [newPrevReads[newPrevReads.count - 1], i]
            } else {
                indexes[output] = [i]
            }
        }
        
        print(to, last)
    }
}
