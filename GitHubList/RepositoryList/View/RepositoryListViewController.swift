//
//  ViewController.swift
//  GitHubList
//
//  Created by Даниил Смирнов on 23.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import UIKit
import Alamofire

class RepostoryListViewController: UIViewController {
	
	@IBOutlet weak var repositoryTableView: UITableView!
	private var loadingAlertController: UIAlertController?
	private let filterActionSheet = UIAlertController(title: "Choose filter option", message: nil, preferredStyle: .actionSheet)
	weak var output: RepositoryListOutput?
	let searchController = UISearchController(searchResultsController: nil)
	var taskForTimeLimit: DispatchWorkItem?
	var dataDisplayManager = RepositoryDataDisplayManager()
	var repositoryListInteractor: RepositoryListInteractor?
	
	override func loadView() {
		super.loadView()
		let networkService = NetworkService()
		repositoryListInteractor = RepositoryListInteractor(networkService)
		repositoryListInteractor?.output = self
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		
		if !isConnectedToInternet() {
			showWarningAlert(with: "No internet connection")
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "repoSelected" {
			
			guard let destinationVc =  segue.destination as? DetailedRepositoryViewController else {
				print("Could not cast to DetailedRepoViewController or its nil")
				return
			}
			
			self.output = destinationVc
		}
	}
	
	func isConnectedToInternet() -> Bool {
		return NetworkReachabilityManager()!.isReachable
	}
	
	func isSearchBarEmpty() -> Bool {
		return searchController.searchBar.text?.isEmpty ?? true
	}
	
	private func setupView() {
		
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search"
		searchController.searchBar.delegate = self
		navigationItem.searchController = searchController
		definesPresentationContext = true
		
		let filterByHightToLowStars = UIAlertAction(title: "Many to few stars", style: .default) { (action) in
			if self.dataDisplayManager.areRepositoriesLoaded() {
				self.dataDisplayManager.filterLoadedRepositories(with: .highToLow)
				self.repositoryTableView.reloadData()
			}
			self.repositoryListInteractor?.setFilter(.highToLow)
		}
		let filterByLowToHighStars = UIAlertAction(title: "Few to many stars", style: .default) { (action) in
			if self.dataDisplayManager.areRepositoriesLoaded() {
				self.dataDisplayManager.filterLoadedRepositories(with: .lowToHigh)
				self.repositoryTableView.reloadData()
			}
			self.repositoryListInteractor?.setFilter(.lowToHigh)
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		filterActionSheet.addAction(filterByHightToLowStars)
		filterActionSheet.addAction(filterByLowToHighStars)
		filterActionSheet.addAction(cancelAction)
		
		repositoryTableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: RepositoryCell.identifier)
		repositoryTableView.delegate = self
		repositoryTableView.dataSource = dataDisplayManager
		
		loadingAlertController = UIAlertController.createLoadingAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
	}
	
	fileprivate func presentAlertQueryInProcess() {
		
		present(loadingAlertController!, animated: true, completion: nil)
		
		let secondsToWait = DispatchTime.now() + 5
		
		let failAlertController = UIAlertController(title: "Connection lost", message: nil, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		
		failAlertController.addAction(okAction)
		
		taskForTimeLimit = DispatchWorkItem {
			self.loadingAlertController?.dismiss(animated: true, completion: nil)
			self.present(failAlertController, animated: true, completion: nil)
		}
		
		DispatchQueue.main.asyncAfter(deadline: secondsToWait, execute: taskForTimeLimit!)
	}
	
	@IBAction func filterButtonPressed(_ sender: Any) {
		present(filterActionSheet, animated: true, completion: nil)
	}
}

// MARK: - UITableViewDelegate
extension RepostoryListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let repositories = dataDisplayManager.getRepositories()
		let selectedRepo = repositories[indexPath.row]
		performSegue(withIdentifier: "repoSelected", sender: self)
		output?.repositoryWasSelected(selectedRepo)
	}
}

// MARK: - RepositoryListInteractorOutput
extension RepostoryListViewController: RepositoryListInteractorOutput {
	
	func errorHappend(_ message: String) {
		
		DispatchQueue.main.async {
			self.showWarningAlert(with: message)
			self.loadingAlertController?.dismiss(animated: true, completion: nil)
		}
		taskForTimeLimit?.cancel()
	}
	
	func sendRepositories(_ repositories: [Repository]) {
		
		DispatchQueue.main.async {
			self.dataDisplayManager.setRepositories(repositories)
			self.repositoryTableView.reloadData()
			self.loadingAlertController?.dismiss(animated: true, completion: nil)
		}
		taskForTimeLimit?.cancel()
	}
}

// MARK: - UISearchBarDelegate
extension RepostoryListViewController: UISearchBarDelegate {
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		
		if isSearchBarEmpty() {
			return
		}
		
		if !isConnectedToInternet() {
			showWarningAlert(with: "No internet connection")
			return
		}
		presentAlertQueryInProcess()
		repositoryListInteractor?.fetchRepositories(with: searchBar.text!)
	}
}








