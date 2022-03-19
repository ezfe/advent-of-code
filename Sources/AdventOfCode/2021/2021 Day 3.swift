//
//  2020 Day 1.swift
//  
//
//  Created by Ezekiel Elin on 12/1/20.
//

import Foundation

struct Day2021_3: Day {
    
    let len = 12
    let bitmask: UInt16 = 0xFFF
    
    func run(input: String) {
        let lines = input
            .split(whereSeparator: \.isNewline)
            .map { UInt16($0, radix: 2)! }
        
        part1(lines: lines)
        part2(lines: lines)
    }
    
    func gamma(lines: [UInt16]) -> UInt16 {
        var gamma: UInt16 = 0
        for i in 0..<len {
            let ones = lines
                .map { $0 >> (len - 1 - i) & 1 }
                .reduce(0, +)
            gamma <<= 1
            if ones >= (UInt16(lines.count) - ones) {
                gamma |= 1
            }
        }
        return gamma
    }
    
    func part1(lines: [UInt16]) {
        let gamma = gamma(lines: lines)
        let epsilon = ~gamma & bitmask
        print(UInt32(gamma) * UInt32(epsilon))
    }
    
    func part2(lines: [UInt16]) {
        var searchBit: UInt16 = 1 << (len - 1)
        
        var oxygenNumbers = lines
        while oxygenNumbers.count > 1 {
            let gamma = gamma(lines: oxygenNumbers)
            let newNumbers = oxygenNumbers.filter {
                ($0 & searchBit) == (gamma & searchBit)
            }
            if newNumbers.isEmpty {
                oxygenNumbers = [oxygenNumbers.last!]
            } else {
                oxygenNumbers = newNumbers
            }
            searchBit >>= 1
        }
        
        searchBit = 1 << (len - 1)
        
        var co2Numbers = lines
        while co2Numbers.count > 1 {
            let gamma = gamma(lines: oxygenNumbers)
            let newNumbers = co2Numbers.filter {
                ($0 & searchBit) != (gamma & searchBit)
            }
            if newNumbers.isEmpty {
                co2Numbers = [co2Numbers.last!]
            } else {
                co2Numbers = newNumbers
            }
            searchBit >>= 1
        }

        print(oxygenNumbers[0])
        print(co2Numbers[0])
        print(UInt32(oxygenNumbers[0]) * UInt32(co2Numbers[0]))
    }
}
