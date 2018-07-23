//
//  RepositoryInteractor.swift
//  GitHubList
//
//  Created by Даниил Смирнов on 23.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import Foundation

class RepositoryListInteractor {

	weak var output: RepositoryListInteractorOutput?
	fileprivate var networkService: NetworkService
	fileprivate var repositoryListNetworkService: RepositoryListNetworkService
	fileprivate var filterOption: FilterOption?
	
	init(_ networkService: NetworkService) {
		
		self.networkService = networkService
		self.repositoryListNetworkService = networkService
		self.repositoryListNetworkService.repositoryListDelegate = self
	}
	
	func setFilter(_ filter: FilterOption) {
		self.filterOption = filter
	}
	
	func fetchRepositories(with name: String) {

		if let filter = filterOption {
			networkService.fetchRepository(with: name, and: filter.rawValue)
		} else {
			networkService.fetchRepository(with: name)
		}
	}
}

// MARK: - RepositoryListNetworkServiceDelegate
extension RepositoryListInteractor: RepositoryListNetworkServiceDelegate {
	
	func repositoryListNetworkServiceDidGet(_ repositories: [Repository]) {
		output?.sendRepositories(repositories)
	}
	
	func queryEndedWithError(_ error: Error) {
		output?.errorHappend("External error")
	}
}
