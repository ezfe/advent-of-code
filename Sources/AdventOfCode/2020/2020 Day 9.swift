//
//  2020 Day 9.swift
//
//
//  Created by Ezekiel Elin on 12/9/20.
//

import Foundation

struct Day2020_9: Day {
    func run(input: String) {
        let lines = input.split(whereSeparator: \.isNewline).map { Int($0)! }
        
        let p1 = part1(lines: lines)
        let p2 = part2(lines: lines, part1: p1)
        
        print(p1)
        print(p2)
    }
    
    func part1(lines: [Int]) -> Int {
        part1MainLoop: for i in 25..<lines.count {
            let range = lines[(i - 25)..<i]
            for combination in range.combinations(ofCount: 2) {
                if combination.reduce(0, +) == lines[i] {
                    continue part1MainLoop
                }
            }
            return lines[i]
        }
        exit(1)
    }
    
    func part2(lines: [Int], part1 p1: Int) -> Int {
        part2MainLoop: for lower in 0..<lines.count {
            for upper in lower..<lines.count {
                let subset = lines[lower...upper]
                if subset.reduce(0, +) == p1 {
                    return subset.min()! + subset.max()!
                }
            }
        }
        exit(1)
    }
}
