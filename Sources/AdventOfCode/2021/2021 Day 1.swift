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
        
        routine(depths: depths, window: 1)
        routine(depths: depths, window: 3)
    }
    
    func sum(_ depths: [Int], from start: Int, window: Int) -> Int {
        var sum = 0
        for delta in 0..<window {
            sum += depths[start - delta]
        }
        return sum
    }
    
    func routine(depths: [Int], window: Int) {
        var increases = 0
        for i in window..<depths.count {
            if sum(depths, from: i, window: window) > sum(depths, from: i - 1, window: window) {
                increases += 1
            }
        }
        
        print(increases)
    }
}
