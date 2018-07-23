//
//  RepositoryListInteractorOutput.swift
//  GitHubList
//
//  Created by Даниил Смирнов on 23.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import Foundation

protocol RepositoryListInteractorOutput: class {
	
	func sendRepositories(_ repositories: [Repository])
	
	func errorHappend(_ message: String)
}
