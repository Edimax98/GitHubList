//
//  RepositoryListOutput.swift
//  GitHubList
//
//  Created by Даниил Смирнов on 23.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import Foundation

protocol RepositoryListOutput: class {
	
	func repositoryWasSelected(_ repository: Repository)
}
