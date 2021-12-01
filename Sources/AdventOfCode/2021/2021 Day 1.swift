//
//  2020 Day 1.swift
//  
//
//  Created by Ezekiel Elin on 12/1/20.
//

import Foundation
import Algorithms

struct Day2021_1: Day {
    func run(input: String) {
        let depths = input
            .split(whereSeparator: \.isNewline)
            .map {
                Int($0)!
            }
        
        part1(depths: depths)
        part2(depths: depths)
    }
    
    func part1(depths: [Int]) {
        var increases = 0
        for i in 1..<depths.count {
            if depths[i] > depths[i - 1] {
                increases += 1
            }
        }
        
        print(increases)
    }
    
    func part2(depths: [Int]) {
        var increases = 0
        for i in 3..<depths.count {
            let current = depths[i] + depths[i-1] + depths[i-2]
            let previous = depths[i-1] + depths[i-2] + depths[i-3]
            if current > previous {
                increases += 1
            }
        }
        
        print(increases)
    }
}
