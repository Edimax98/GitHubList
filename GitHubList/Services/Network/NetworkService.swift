//
//  NetworkService.swift
//  GitHubList
//
//  Created by Даниил Смирнов on 23.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkService {
	private let apiUrl = "https://api.github.com/search/repositories"
	weak var repositoryListDelegate: RepositoryListNetworkServiceDelegate?
}

extension NetworkService: RepositoryListNetworkService {
	
	func fetchRepository(with name: String, and filter: String) {
		
		let fetchingQueue = DispatchQueue.global(qos: .utility)
		
		request(apiUrl, method: .get, parameters: ["q":name, "sort":FilterOption.sortOption, "order":filter], encoding: URLEncoding(), headers: nil)
			.validate()
			.response(queue: fetchingQueue, responseSerializer: DataRequest.jsonResponseSerializer(), completionHandler: { (response) in
				
				guard let responseValue = response.result.value else {
					print("Repos list raw json is nil")
					return
				}
				
				let json = JSON(responseValue)
				
				switch response.result {
				case .success(_):
					
					let repos = json["items"].array?.map { (jsonMap) -> Repository in
						Repository(title: jsonMap["name"].stringValue, countOfStars: jsonMap["stargazers_count"].intValue, authorName: jsonMap["owner"]["login"].stringValue, language: jsonMap["language"].stringValue, description: jsonMap["description"].stringValue)
					}
					
					guard let reposToSend = repos else {
						print("Repos array is nil after being parsed")
						return
					}
					
					self.repositoryListDelegate?.repositoryListNetworkServiceDidGet(reposToSend)
					
				case .failure(let error):
					self.repositoryListDelegate?.queryEndedWithError(error)
				}
			})
	}
	
	
	func fetchRepository(with name: String) {
		
		let fetchingQueue = DispatchQueue.global(qos: .utility)
		
		request(apiUrl, method: .get, parameters: ["q":name], encoding: URLEncoding(), headers: nil)
			.validate()
			.response(queue: fetchingQueue, responseSerializer: DataRequest.jsonResponseSerializer(), completionHandler: { (response) in
				
				guard let responseValue = response.result.value else {
					print("Repos list raw json is nil")
					return
				}
				
				let json = JSON(responseValue)
				
				let repos = json["items"].array?.map { (jsonMap) -> Repository in
					Repository(title: jsonMap["name"].stringValue, countOfStars: jsonMap["stargazers_count"].intValue, authorName: jsonMap["owner"]["login"].stringValue, language: jsonMap["language"].stringValue, description: jsonMap["description"].stringValue)
				}
				
				guard let reposToSend = repos else {
					print("Repos array is nil after being parsed")
					return
				}
				
				self.repositoryListDelegate?.repositoryListNetworkServiceDidGet(reposToSend)
			})
	}
}
