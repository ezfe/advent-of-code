import Foundation
import ArgumentParser

struct AOCLauncher: ParsableCommand {
    @Argument(help: "The AOC-2019 day to run")
    var day: Int = 7

    @Argument(help: "The input file path")
    var filePath: String = "/Users/ezekielelin/github_repositories/advent-of-code-2019/input-7.txt"

    static var days: [Int: Day] = [
        1: Day1(),
        2: Day2(),
        5: Day5(),
        7: Day7()
    ]

    func validate() throws {
        guard AOCLauncher.days.keys.contains(self.day) else {
            throw ValidationError("Please specify a day in \(AOCLauncher.days.keys.sorted())")
        }
    }

    mutating func run() throws {
        let url = URL(fileURLWithPath: self.filePath)
        let input = try String(contentsOf: url)

        let day = AOCLauncher.days[self.day]!

        let start = CFAbsoluteTimeGetCurrent()
        day.run(input: input)
        let end = CFAbsoluteTimeGetCurrent()

        let elapsed = end - start
        let micro = elapsed * 1000000
        print("Completed Day \(self.day) in \(micro) μs")
    }
}

protocol Day: Codable {
    func run(input: String)
}

AOCLauncher.main()
