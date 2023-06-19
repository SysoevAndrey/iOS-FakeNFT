import UIKit

final class CartViewController: UIViewController {

    // MARK: - Layout elements

    private lazy var sortButton = UIBarButtonItem(
        image: UIImage.Icons.sort,
        style: .plain,
        target: self,
        action: #selector(didTapSortButton)
    )
    
    private let summaryView = SummaryView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapSortButton() {
        // TODO: добавить сортировку
    }
}

// MARK: - Layout methods

private extension CartViewController {

    func setupView() {
        setupNavBar()
        view.addSubview(summaryView)
        setupConstraints()
    }

    func setupNavBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = sortButton
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // summaryView
            summaryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            summaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
