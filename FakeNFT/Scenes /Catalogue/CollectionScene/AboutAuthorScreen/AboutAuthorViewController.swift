//
//  AboutAuthorViewController.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 01.07.2023.
//

import UIKit
import WebKit

final class AboutAuthorViewController: UIViewController, UIGestureRecognizerDelegate {
    private var viewModel: AboutAuthorViewModel
    
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
    
    init(viewModel: AboutAuthorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        loadPage()
    }
    
    private func bindViewModel() {
        viewModel.$loadingInProgress.bind { [weak self] _ in
            guard let self = self else { return }
            if self.viewModel.loadingInProgress {
                UIBlockingProgressHUD.show()
            } else {
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func loadPage() {
        guard let url = URL(string: viewModel.authorPageURL) else { return }
        
        let request = URLRequest(url: url)
        webView.navigationDelegate = self
        
        viewModel.changeLoadingStatus(loadingInProgress: true)
        webView.load(request)
    }
}

private extension AboutAuthorViewController {
    func setupView() {
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
        
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
        viewModel.changeLoadingStatus(loadingInProgress: false)
    }
}
