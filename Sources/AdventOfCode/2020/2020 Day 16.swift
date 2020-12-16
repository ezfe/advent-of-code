//
//  2020 Day 16.swift
//  
//
//  Created by Ezekiel Elin on 12/16/20.
//

import Foundation

struct Day2020_16: Day {
    struct Constraint {
        let name: String
        let ranges: [(Int, Int)]
    }
    
    func run(input: String) {
        let lines = input.split(whereSeparator: \.isNewline)
        
        let ytIndex = lines.firstIndex(of: "your ticket:")!
        let nbtIndex = lines.firstIndex(of: "nearby tickets:")!
        
        let constraints = lines[..<ytIndex]
            .map { parameterToken -> Constraint in
                let tokens = parameterToken.split(separator: ":")
                let name = String(tokens[0])
                
                let rangeTokens = tokens[1].dropFirst().split(separator: "o")
                let range1 = rangeTokens[0].dropLast().split(separator: "-")
                let range2 = rangeTokens[1].dropFirst(2).split(separator: "-")
                
                return Constraint(name: name,
                                  ranges: [
                                    (Int(range1[0])!, Int(range1[1])!),
                                    (Int(range2[0])!, Int(range2[1])!)
                                  ])
            }
        let yourTicket = lines[(ytIndex + 1)..<nbtIndex]
            .first!
            .split(separator: ",")
            .map { Int($0)! }
        let nearbyTickets = lines[(nbtIndex + 1)...]
            .map {
                $0.split(separator: ",")
                    .map { Int($0)! }
            }
        
        // Part 1
        let failedSum = nearbyTickets
            .map { failedValues(ticket: $0, constraints: constraints) }
            .reduce([], +)
            .reduce(0, +)
        
        print(failedSum)
        
        // Part 2
        let ticketsPassing = nearbyTickets.filter {
            isValid(ticket: $0, constraints: constraints)
        }
        
    }
    
    func failedValues(ticket: [Int], constraints: [Constraint]) -> [Int] {
        var failedValues = [Int]()
        
        ticketLoop: for value in ticket {
            for constraint in constraints {
                for range in constraint.ranges {
                    if value >= range.0 && value <= range.1 {
                        continue ticketLoop // value passes with this constraint
                    }
                }
            }
            failedValues.append(value)
        }
        
        return failedValues
    }
    
    func isValid(ticket: [Int], constraints: [Constraint]) -> Bool {
        ticketLoop: for value in ticket {
            for constraint in constraints {
                for range in constraint.ranges {
                    if value >= range.0 && value <= range.1 {
                        continue ticketLoop // value passes with this constraint
                    }
                }
            }
            break
        }
        return false
    }
    
    func determineLabels(tickets: [[Int]], constraints: [Constraint]) -> [String] {
        var labels: [String?] = Array(repeating: nil, count: tickets.first!.count)
        
        for i in 0..<labels.count {
            // to-do
        }
        
        return labels.map { $0! }
    }
}
