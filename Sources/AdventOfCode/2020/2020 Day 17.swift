//
//  2020 Day 17.swift
//  
//
//  Created by Ezekiel Elin on 12/22/20.
//

import Foundation

struct Day2020_17: Day {
    struct Coord: Hashable, Equatable {
        let x: Int
        let y: Int
        let z: Int
        
        init(_ x: Int, _ y: Int, _ z: Int = 0) {
            self.x = x
            self.y = y
            self.z = z
        }
    }
    
    enum State: Character {
        case active = "#"
        case inactive = "."
    }
    
    func run(input: String) {
        let lines = input
            .split(whereSeparator: \.isNewline)
            .map { line in
                line.map { State(rawValue: $0)! }
            }

        var grid = [Coord: State]()
        for (y, line) in lines.enumerated() {
            for (x, cell) in line.enumerated() {
                let c = Coord(x, y)
                grid[c] = cell
            }
        }
        
        var new = grid
        for i in 0...3 {
            print("===\(i)===")
            printGrid(grid: new, at: -2)
            printGrid(grid: new, at: -1)
            printGrid(grid: new, at: 0)
            printGrid(grid: new, at: 1)
            printGrid(grid: new, at: 2)
            new = advance(grid: new)
        }
    }
    
    func advance(grid: [Coord: State]) -> [Coord: State] {
        if grid.isEmpty {
            return [:]
        }
        var minimum = Coord(Int.max, Int.max, Int.max)
        var maximum = Coord(Int.min, Int.min, Int.min)
        for coord in grid.keys {
            minimum = Coord(min(minimum.x, coord.x), min(minimum.y, coord.y), min(minimum.z, coord.z))
            maximum = Coord(max(minimum.x, coord.x), max(minimum.y, coord.y), max(minimum.z, coord.z))
        }
        minimum = Coord(minimum.x - 1, minimum.y - 1, minimum.z - 1)
        maximum = Coord(maximum.x + 1, maximum.y + 1, maximum.z + 1)
        
        var new = [Coord: State]()
        for x in minimum.x...maximum.x {
            for y in minimum.y...maximum.y {
                for z in minimum.z...maximum.z {
                    let loc = Coord(x, y, x)
                    let state = grid[loc] ?? .inactive
                    // Determine Neighbor Active Count
                    var found = sum(grid: grid, from: Coord(x - 1, y - 1, z - 1), to: Coord(x + 1, y + 1, z + 1))
                    if state == .active {
                        found -= 1 // adjust to make sum accurate
                    }
                    // Determine New State
                    switch state {
                        case .active:
                            if found == 2 || found == 3 {
                                new[loc] = .active
                            }
                            // no need to store inactive
                        case .inactive:
                            if found == 3 {
                                new[loc] = .active
                            }
                    }
                }
            }
        }
        return new
    }
    
    func sum(grid: [Coord: State], from minimum: Coord, to maximum: Coord) -> Int {
        var sum = 0
        for x in minimum.x...maximum.x {
            for y in minimum.y...maximum.y {
                for z in minimum.z...maximum.z {
                    if let state = grid[Coord(x, y, z)], state == .active {
                        sum += 1
                    }
                }
            }
        }
        return sum
    }
    
    func printGrid(grid: [Coord: State], at z: Int = 0) {
        if (grid.isEmpty) {
            print("[Empty]")
            return
        }
        var yMin = Int.max
        var yMax = Int.min
        var xMin = Int.max
        var xMax = Int.min
        for coord in grid.keys {
            xMin = min(xMin, coord.x)
            xMax = max(xMax, coord.x)
            yMin = min(yMin, coord.y)
            yMax = max(yMax, coord.y)
        }
        print("---")
        for y in yMin...yMax {
            for x in xMin...xMax {
                let state = grid[Coord(x, y, z)] ?? .inactive
                print(state.rawValue, terminator: "")
            }
            print("")
        }
    }
}
