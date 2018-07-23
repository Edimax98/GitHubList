//
//  QueryErrorHandler.swift
//  GitHubList
//
//  Created by Даниил Смирнов on 23.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import Foundation

protocol QueryErrorHandler: class {
	
	func queryEndedWithError(_ error: Error)
}
