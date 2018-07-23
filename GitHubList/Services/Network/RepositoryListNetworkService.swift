//
//  RepositoryListNetworkService.swift
//  GitHubList
//
//  Created by Даниил Смирнов on 23.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import Foundation

protocol RepositoryListNetworkServiceDelegate: QueryErrorHandler {
	
	func repositoryListNetworkServiceDidGet(_ repositories: [Repository])
}

protocol RepositoryListNetworkService {
	
	var repositoryListDelegate: RepositoryListNetworkServiceDelegate? { get set}
	
	func fetchRepository(with name: String)
	
	func fetchRepository(with name: String, and filter: String)
}
