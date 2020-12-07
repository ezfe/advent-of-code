//
//  2020 Day 7.swift
//  
//
//  Created by Ezekiel Elin on 12/7/20.
//

import Foundation

struct Day2020_7: Day {
    func run(input: String) {
        let lines = input.split(whereSeparator: \.isNewline).map(String.init)

        let rules: [Rule] = lines.map { line in
            guard let containsIndex = line.range(of: " bags contain") else {
                print("Failed to parse ` bags contains ` in \(line)")
                exit(1)
            }
            let outer = String(line[..<containsIndex.lowerBound])
            let rest = String(line[containsIndex.upperBound...].dropLast())
            let split = rest.split(separator: ",")
            var inner = [String: Int]()
            split.forEach { el in
                let colorWithBags = el.dropFirst(1)
                if colorWithBags == "no other bags" {
                    return
                }
                let qtyColor = colorWithBags.replacingOccurrences(of: " bags", with: "").replacingOccurrences(of: " bag", with: "")
                
                let firstSpace = qtyColor.firstIndex(of: " ")!
                let qty = Int(qtyColor[..<firstSpace])
                let color = String(qtyColor[firstSpace...].dropFirst())
                
                inner[color] = qty
            }
            
            return Rule(outer: outer, inner: inner)
        }

        run1(rules: rules)
        run2(rules: rules)
    }
    
    func run1(rules: [Rule]) {
        var total = Set(["shiny gold"])
        var layers = [Set(["shiny gold"])]
        while true {
            guard let topLayer = layers.last else { break }
            var working = Set<String>()
            for color in topLayer {
                let filteredRules = rules.filter { $0.inner[color] != nil }
                let outerColors = filteredRules.map { $0.outer }
                working.formUnion(outerColors)
            }
            if working.subtracting(total).isEmpty {
                break
            } else {
                total.formUnion(working)
            }
            layers.append(working)
        }
        print(Set(layers.dropFirst().reduce([], +)).count)
    }
    
    func run2(rules: [Rule]) {
        print(countContents(color: "shiny gold", rules: rules))
    }
    
    func countContents(color: String, rules: [Rule]) -> Int {
        guard let target = rules.first(where: { $0.outer == color }) else {
            print("Failed to identify rule for outer color = \(color)")
            return 0
        }
        
        if target.inner.isEmpty { return 0 }
        
        return target.inner.map { (innerColor, innerCount) in
            return innerCount * (1 + countContents(color: innerColor, rules: rules))
        }.reduce(0, +)
    }
    
    struct Rule {
        let outer: String
        let inner: Dictionary<String, Int>
    }
}
