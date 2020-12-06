//
//  2020 Day 6.swift
//  
//
//  Created by Ezekiel Elin on 12/5/20.
//

import Foundation

struct Day2020_6: Day {
    func run(input: String) {
        let lines = input.split(omittingEmptySubsequences: false, whereSeparator: \.isWhitespace).map(String.init)
        let groups = lines.split(whereSeparator: { $0.isEmpty })
        
        run1(groups: groups)
        run2(groups: groups)
    }
    
    func run1(groups: [Array<String>.SubSequence]) {
        let setted: [Set<Character>] = groups.map { lines in
            var set = Set<Character>()
            lines.forEach { line in
                Array(line).forEach {
                    set.insert($0)
                }
            }
            return set
        }

        let counts = setted.map { $0.count }
        print(counts.reduce(0, +))
    }
    
    func run2(groups: [Array<String>.SubSequence]) {
        let setted: [Set<Character>] = groups.map { lines in
            let sets = lines.map(Set.init)
            guard var master = sets.first else {
                return []
            }
            for set in sets.dropFirst() {
                master = master.intersection(set)
            }
            return master
        }
        
        let counts = setted.map { $0.count }
        print(counts.reduce(0, +))
    }
}
