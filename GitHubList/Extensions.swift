//
//  Extensions.swift
//  GitHubList
//
//  Created by Даниил Смирнов on 23.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import UIKit

extension UIAlertController {
	
	static func createLoadingAlertController(title: String?, message: String, preferredStyle: UIAlertControllerStyle) -> UIAlertController {
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
		
		alert.view.tintColor = UIColor.black
		let spinner = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
		spinner.hidesWhenStopped = true
		spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
		spinner.startAnimating()
		alert.view.addSubview(spinner)
		return alert
	}
}

extension UIViewController {
	
	func showWarningAlert(with title: String) {
		
		let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
		alert.addAction(okAction)
		present(alert, animated: true, completion: nil)
	}
}
