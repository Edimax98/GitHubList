//
//  RepositoryCell.swift
//  GitHubList
//
//  Created by Даниил Смирнов on 23.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {
	
	@IBOutlet weak var repositoryNameLabel: UILabel!
	@IBOutlet weak var repositoryAuthorLabel: UILabel!
	@IBOutlet weak var repositoryStarsLabel: UILabel!
	
	static var identifier: String {
		return "RepositoryCell"
	}
}
