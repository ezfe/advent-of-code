//
//  2022 Day 7.swift
//  
//
//  Created by Ezekiel Elin on 12/7/22.
//

import Foundation

struct Day2022_7: Day {
	//MARK: - File System Representation

	class Directory: CustomStringConvertible {
		let parent: Directory?
		let name: String?
		
		var files: [String: Int]
		private(set) var directories: [Directory]
		
		init() {
			self.parent = nil
			self.name = nil
			self.files = [:]
			self.directories = []
		}
		
		init(parent: Directory, name: String) {
			self.parent = parent
			self.name = name
			self.files = [:]
			self.directories = []
		}
		
		@discardableResult
		func add(child directoryName: String) -> Directory {
			let newDirectory = Directory(parent: self, name: directoryName)
			self.directories.append(newDirectory)
			return newDirectory
		}
		
		lazy var size: Int = {
			let fileSize = files.values.sum()
			let childDirectorySize = directories.map(\.size).sum()
			return fileSize + childDirectorySize
		}()
		
		lazy var allChildDirectories: [Directory] = {
			let immediates = directories
			let subLevels = directories.map(\.allChildDirectories).reduce([], +)
			return immediates + subLevels
		}()
		
		var description: String {
			return "Directory{name=\(name ?? "none"),parent=\(parent?.name ?? "none"),size=\(size),subdirs=\(directories.count),files=\(files.count)}"
		}
	}
	
	//MARK: - Input Representation

	enum LsResults: CustomStringConvertible {
		case directory(String)
		case file(String, Int)
		
		var description: String {
			switch self {
				case .directory(let name):
					return "dir{\(name)}"
				case .file(let name, let size):
					return "file{\(name), \(size)}"
			}
		}
	}
	
	enum CdTarget: CustomStringConvertible {
		case `in`(String)
		case out
		
		var description: String {
			switch self {
				case .in(let name):
					return String(name)
				case .out:
					return ".."
			}
		}
	}

	enum Command: CustomStringConvertible {
		case cd(CdTarget)
		case ls([LsResults])
		
		var description: String {
			switch self {
				case .cd(let path):
					return "cd{\(path)}"
				case .ls(let files):
					return "ls{\(files)}"
			}
		}
	}
	
	// MARK: - Script
	
	func run(input: String) async -> (Int?, Int?) {
		let commands = input.split(separator: "$ ").map { commandString in
			if commandString.starts(with: "cd") {
				let target = commandString.dropFirst(3).dropLast()
				if target == ".." {
					return Command.cd(.out)
				} else {
					return Command.cd(.in(String(target)))
				}
			} else if commandString.starts(with: "ls") {
				let lsResults = commandString.split(whereSeparator: \.isNewline).dropFirst().map { dirDesc in
					let components = dirDesc.split(whereSeparator: \.isWhitespace)
					if components[0] == "dir" {
						return LsResults.directory(String(components[1]))
					} else {
						return LsResults.file(String(components[1]), components[0].integer)
					}
				}
				return Command.ls(lsResults)
			} else {
				fatalError("Illegal command: \(commandString)")
			}
		}
		
		let fs = Directory()
		var current = fs
		
		for command in commands {
			switch command {
				case .cd(let target):
					switch target {
						case .out:
							if let parent = current.parent {
								current = parent
							} else {
								fatalError("Directory does not have parent!")
							}
						case .in(let dirName):
							if let childDirectory = current.directories.first(where: { $0.name == dirName }) {
								current = childDirectory
							} else if dirName == "/" {
								current = fs
							} else {
								fatalError("Directory does not have child: \(dirName)")
							}
					}
				case .ls(let lsResults):
					for result in lsResults {
						switch result {
							case .file(let fileName, let fileSize):
								current.files[fileName] = fileSize
							case .directory(let dirName):
								current.add(child: dirName)
						}
					}
			}
		}
		
		let size_leq_100000 = fs.allChildDirectories.filter { $0.size <= 100_000 }.map(\.size).sum()
		
		let total_disk = 70_000_000
		let required_avail = 30_000_000
		let actual_avail = total_disk - fs.size
		let needed = required_avail - actual_avail

		let smallest_geq_needed = fs.allChildDirectories.filter { $0.size >= needed }.sorted { $0.size < $1.size }.first!
		
		return (size_leq_100000, smallest_geq_needed.size)
	}
}
