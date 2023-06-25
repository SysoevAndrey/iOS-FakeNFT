import UIKit
import WebKit

final class UserAgreementViewController: UIViewController {
    
    // MARK: - Layout elements
    
    private let webView = WKWebView()
    private lazy var backButton = UIBarButtonItem(
        image: UIImage.Icons.back,
        style: .plain,
        target: self,
        action: #selector(didTapBackButton)
    )

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadPage()
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private
    
    private func loadPage() {
        let request = URLRequest(url: Constants.userAgreementUrl)
        webView.load(request)
    }
}

// MARK: - Layout methods

private extension UserAgreementViewController {

    func setupView() {
        view.backgroundColor = .white
        
        [webView]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

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
            // webView
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

private extension UserAgreementViewController {

    enum Constants {
        static let userAgreementUrl: URL = URL(string: "https://yandex.ru/legal/practicum_termsofuse")!
    }
}

// MARK: - UIGestureRecognizerDelegate

extension UserAgreementViewController: UIGestureRecognizerDelegate {}
