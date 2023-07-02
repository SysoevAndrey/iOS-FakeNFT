//
//  AboutAuthorViewController.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 01.07.2023.
//

import UIKit
import WebKit

final class AboutAuthorViewController: UIViewController, UIGestureRecognizerDelegate {
	private var authorPageURL: String?
	
	private lazy var webView: WKWebView = {
		let webView = WKWebView()
		return webView
	}()
	
	private lazy var backButton = UIBarButtonItem(
		image: UIImage.Icons.back,
		style: .plain,
		target: self,
		action: #selector(didTapBackButton)
	)

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		loadPage()
	}
	
	func inialise(authorPageURL: String) {
		self.authorPageURL = authorPageURL
	}

	@objc
	private func didTapBackButton() {
		navigationController?.popViewController(animated: true)
	}
	
	private func loadPage() {
		guard let authorPageStringURL = authorPageURL,
			  let url = URL(string: authorPageStringURL) else { return }
		
		let request = URLRequest(url: url)
		webView.navigationDelegate = self
		
		UIBlockingProgressHUD.show()
		webView.load(request)
	}
}

private extension AboutAuthorViewController {
	func setupView() {
		view.backgroundColor = .white

		webView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(webView)

		setupNavBar()
		setupConstraints()
	}

	func setupNavBar() {
		navigationController?.navigationBar.barTintColor = .white
		navigationItem.leftBarButtonItem = backButton
		navigationController?.interactivePopGestureRecognizer?.delegate = self
	}

	func setupConstraints() {
		NSLayoutConstraint.activate([
			webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}

extension AboutAuthorViewController: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		UIBlockingProgressHUD.dismiss()
	}
}
