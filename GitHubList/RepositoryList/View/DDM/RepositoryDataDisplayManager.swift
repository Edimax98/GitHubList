//
//  RepositoryDataDisplayManager.swift
//  GitHubList
//
//  Created by Даниил Смирнов on 23.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import UIKit

class RepositoryDataDisplayManager: NSObject {
	
	private var repositories = [Repository]()
	private var reposWasLoaded = false
	
	func setRepositories(_ repositories: [Repository]) {
		self.repositories = repositories
		reposWasLoaded = true
	}
	
	func getRepositories() -> [Repository] {
		return self.repositories
	}
	
	func areRepositoriesLoaded() -> Bool {
		return reposWasLoaded
	}
	
	func filterLoadedRepositories(with filter: FilterOption) {
		
		switch filter {
		case .lowToHigh:
			self.repositories = self.repositories.sorted { $0.countOfStars < $1.countOfStars }
		case .highToLow:
			self.repositories = self.repositories.sorted { $0.countOfStars > $1.countOfStars }
		}
	}
}

// MARK: - UITableViewDataSource
extension RepositoryDataDisplayManager: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return repositories.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let repository = repositories[indexPath.row]
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.identifier, for: indexPath) as? RepositoryCell else {
			print("Could not deque cell with identifier - \(RepositoryCell.identifier)")
			return UITableViewCell()
		}
		
		cell.repositoryAuthorLabel.text = "Author: " + repository.authorName
		cell.repositoryNameLabel.text = repository.title
		cell.repositoryStarsLabel.text = "\(repository.countOfStars) stars"
		
		return cell
	}
}
