//
//  File.swift
//  
//
//  Created by Ezekiel Elin on 11/30/22.
//

import Foundation

func concurrentPerform<Input, Output: Sendable>(
	input: [Input],
	map: @escaping (Input) async -> Output
) async -> [Output] {
	
	return await withTaskGroup(of: Output.self) { taskGroup in
		for i in input {
			taskGroup.addTask {
				return await map(i)
			}
		}
		
		let results = await taskGroup.reduce(into: []) { partialResult, output in
			partialResult.append(output)
		}
		return results
	}
}
