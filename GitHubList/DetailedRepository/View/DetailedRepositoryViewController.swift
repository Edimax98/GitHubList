//
//  DetailedRepositoryViewController.swift
//  GitHubList
//
//  Created by Даниил Смирнов on 23.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import UIKit

class DetailedRepositoryViewController: UITableViewController {

	@IBOutlet weak var repositoryNameTextView: UITextView!
	@IBOutlet weak var repositoryStarsTextView: UITextView!
	@IBOutlet weak var repositoryLanguageTextView: UITextView!
	@IBOutlet weak var repositoryAuthorTextView: UITextView!
	@IBOutlet weak var repositoryDescriptionTextView: UITextView!
	var repository: Repository?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		guard let repo = repository else {
			print("repo is nil")
			return
		}
		
		repositoryNameTextView.text = repo.title
		repositoryStarsTextView.text = "\(repo.countOfStars)"
		repositoryAuthorTextView.text = repo.authorName
		repositoryLanguageTextView.text = repo.language
		repositoryDescriptionTextView.text = repo.description
		
		self.title = repositoryNameTextView.text
    }
}

// MARK: - RepositoryListOutput
extension DetailedRepositoryViewController: RepositoryListOutput {
	
	func repositoryWasSelected(_ repository: Repository) {
		self.repository = repository
	}
}

