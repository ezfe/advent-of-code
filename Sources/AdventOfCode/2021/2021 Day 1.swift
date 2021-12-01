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
    
    func routine(depths: [Int], window windowSize: Int) {
        let _windows = depths.windows(ofCount: windowSize)
        let windows = Array(_windows)
        
        var increases = 0
        for i in 1..<windows.count {
            if windows[i].reduce(0, +) > windows[i - 1].reduce(0, +) {
                increases += 1
            }
        }
        
        print(increases)
    }
}
