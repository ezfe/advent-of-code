import ArgumentParser
import Foundation

@main
struct AOCLauncher: AsyncParsableCommand {
	@Argument(help: "The year to run")
	var year: Int = 2022
	
	@Argument(help: "The day to run")
	var day: Int = 1
	
	@Argument(help: "The input file path")
	var filePath: String?
	
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
					let filePath = folderInput.appending(component: fileName)
					try await run(inputFile: filePath, label: fileName)
				}
			} else {
				print("Failed to find input for \(year)/input-\(day)(.txt)?")
			}
		}
	}
	
	private func run(inputFile: URL, label: String) async throws {
		print("=== Starting Day \(self.day) <\(label)> ===")
		let input = try String(contentsOf: inputFile)
		
		let year = AOCLauncher.years[self.year]!
		let day = year.entryPoints[self.day]!
		
		let start = CFAbsoluteTimeGetCurrent()
		await day.run(input: input)
		let end = CFAbsoluteTimeGetCurrent()
		
		let elapsed = end - start
		let micro = elapsed * 1000000
		print("=== Completed Day \(self.day) <\(label)> in \(micro) μs ===")
	}
}
