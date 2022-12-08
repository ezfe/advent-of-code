import ArgumentParser
import Foundation

@main
struct AOCLauncher: AsyncParsableCommand {
	@Option(name: .shortAndLong, help: "The year to run")
	var year: Int = 2022
	
	@Option(name: .shortAndLong, help: "The day to run")
	var day: Int = 7
	
	@Option(name: .shortAndLong, help: "The input file path")
	var filePath: String?
	
	@Option(name: .shortAndLong, help: "Session cookie for Advent of Code website")
	var aocToken: String?
	
	@Option(name: .shortAndLong, help: "Run multiple iterations. Only applies when sourced from AOC website")
	var iterations: UInt = 1
	
	static var years: [Int: EntryPoints] = [
		2015: EntryPoints2015(),
		2019: EntryPoints2019(),
		2020: EntryPoints2020(),
		2021: EntryPoints2021(),
		2022: EntryPoints2022(),
	]
	
	func validate() throws {
		guard AOCLauncher.years.keys.contains(self.year) else {
			throw ValidationError("Please specify a year in \(AOCLauncher.years.keys.sorted())")
		}
		if let yearEntry = AOCLauncher.years[self.year] {
			guard yearEntry.entryPoints.keys.contains(self.day) else {
				throw ValidationError("Please specify a day in \(yearEntry.entryPoints.keys.sorted())")
			}
		}
	}
	
	mutating func run() async throws {
		if let filePath = self.filePath {
			let url = URL(fileURLWithPath: filePath)
			try await self.run(inputFile: url, label: "argument")
		} else {
			let inputDir = URL(filePath: "/Users/ezekielelin/github_repositories/advent-of-code/Input/\(year)/", directoryHint: .isDirectory)
			let singleInput = inputDir.appending(component: "input-\(day).txt")
			let folderInput = inputDir.appending(component: "input-\(day)")
			
			var foundMain = false
			let fm = FileManager.default
			if fm.fileExists(atPath: singleInput.path) {
				try await self.run(inputFile: singleInput, label: "main")
			} else if (fm.fileExists(atPath: folderInput.path)) {
				let contents = try fm.contentsOfDirectory(atPath: folderInput.path).filter { file in
					file.hasSuffix(".txt")
				}.sorted(by: { fn1, fn2 in
					if fn1 == "main.txt" {
						return false
					} else {
						return fn1 > fn2
					}
				})

				for fileName in contents {
					if fileName == "main.txt" {
						foundMain = true
					}
					let filePath = folderInput.appending(component: fileName)
					try await run(inputFile: filePath, label: fileName)
				}
			}

			if !foundMain {
				if let aocToken, let url = URL(string: "https://adventofcode.com/\(year)/day/\(day)/input") {
					var request = URLRequest(url: url)
					request.setValue("session=\(aocToken)",
										  forHTTPHeaderField: "Cookie")
					request.setValue("https://github.com/ezfe/advent-of-code; aoc-ua-contact@ezekiel.dev",
										  forHTTPHeaderField: "User-Agent")
					let (data, response) = try await URLSession.shared.data(for: request)
					if let responseText = String(data: data, encoding: .utf8),
						responseText.matches(of: "Please log in").isEmpty {
						if responseText.matches(of: "don't repeatedly request this endpoint").isEmpty {
							try await run(input: responseText, label: "auto-generated-request", repeated: iterations)
						} else {
							print("Puzzle \(year)/\(day) not yet available")
						}
					} else {
						print("Failed to retrieve text from adventofcode.com")
						print(response)
					}
				}
			}
		}
	}
	
	private func run(inputFile: URL, label: String) async throws {
		let input = try String(contentsOf: inputFile)
		try await run(input: input, label: label)
	}
	
	private func run(input: String, label: String, repeated runCount: UInt = 1) async throws {
		print("=== Starting Day \(self.day) <\(label)> ===")
		let year = AOCLauncher.years[self.year]!
		let day = year.entryPoints[self.day]!
		
		var runTimes = [Double]()
		for i in 0..<runCount {
			let start = CFAbsoluteTimeGetCurrent()
			let (part1, part2) = await day.run(input: input)
			let end = CFAbsoluteTimeGetCurrent()
			let micro = (end - start) * 1000000
			runTimes.append(micro)
			
			if i == 0 {
				if let part1 {
					print("Part 1: \(part1)")
				}
				if let part2 {
					print("Part 2: \(part2)")
				}
			}
		}
		
		let averageMicro = runTimes.average()
		let stdDevMicro = runTimes.standardDeviation()
		
		if !stdDevMicro.isNaN {
			print("=== Completed Day \(self.day) <\(label)> – \(Int(averageMicro)) ± \(stdDevMicro) μs / \(runCount) iterations ===")
		} else {
			print("=== Completed Day \(self.day) <\(label)> – \(Int(averageMicro)) μs ===")
		}
	}
}
