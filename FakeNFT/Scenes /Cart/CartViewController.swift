import UIKit

final class CartViewController: UIViewController {

    // MARK: - Layout elements

    private let summaryView = SummaryView()
    private lazy var sortButton = UIBarButtonItem(
        image: UIImage.Icons.sort,
        style: .plain,
        target: self,
        action: #selector(didTapSortButton)
    )
    
    // MARK: - Properties
    
    private var viewModel: CartViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = CartViewModel(viewController: self)
        bind()
        viewModel?.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapSortButton() {
        // TODO: добавить сортировку
    }
    
    // MARK: - Private
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        viewModel.onChange = { [weak self] in
            self?.summaryView.configure(with: viewModel.summaryInfo)
        }
    }
}

// MARK: - Layout methods

private extension CartViewController {

    func setupView() {
        view.addSubview(summaryView)
        setupNavBar()
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
