import Foundation
import ArgumentParser

struct AOCLauncher: ParsableCommand {
    @Argument(help: "The year to run")
    var year: Int = 2020
    
    @Argument(help: "The day to run")
    var day: Int = 6

    @Argument(help: "The input file path")
    var filePath: String?

    static var years: [Int: [Int: Day]] = [
        2015: entryPoints2015,
        2019: entryPoints2019,
        2020: entryPoints2020
    ]

    func validate() throws {
        guard AOCLauncher.years.keys.contains(self.year) else {
            throw ValidationError("Please specify a year in \(AOCLauncher.years.keys.sorted())")
        }
        if let yearEntry = AOCLauncher.years[self.year] {
            guard yearEntry.keys.contains(self.day) else {
                throw ValidationError("Please specify a day in \(yearEntry.keys.sorted())")
            }
        }
    }

    mutating func run() throws {
        let url: URL
        if let filePath = self.filePath {
            url = URL(fileURLWithPath: filePath)
        } else {
            url = URL(fileURLWithPath: "/Users/ezekielelin/github_repositories/advent-of-code/Input/\(year)/input-\(day).txt")
        }
        let input = try String(contentsOf: url)

        let year = AOCLauncher.years[self.year]!
        let day = year[self.day]!

        let start = CFAbsoluteTimeGetCurrent()
        day.run(input: input)
        let end = CFAbsoluteTimeGetCurrent()

        let elapsed = end - start
        let micro = elapsed * 1000000
        print("Completed Day \(self.day) in \(micro) μs")
    }
}

protocol Day {
    func run(input: String)
}

AOCLauncher.main()
