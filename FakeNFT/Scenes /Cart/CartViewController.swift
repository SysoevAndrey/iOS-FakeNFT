import ProgressHUD
import UIKit

final class CartViewController: UIViewController {

    // MARK: - Layout elements

    private let summaryView = SummaryView()
    private lazy var nftsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.register(CartNFTCell.self)
        return tableView
    }()
    private lazy var sortButton = UIBarButtonItem(
        image: UIImage.Icons.sort,
        style: .plain,
        target: self,
        action: #selector(didTapSortButton)
    )
    
    // MARK: - Properties
    
    private var viewModel: CartViewModel?
    private var summaryViewTopConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProgressHUD.show()
        
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
        
        viewModel.onLoad = { [weak self] in
            guard let self else { return }
            self.summaryView.configure(with: viewModel.summaryInfo)
            self.nftsTableView.reloadData()
            UIView.animate(withDuration: 0.3) {
                self.summaryViewTopConstraint?.constant = -self.summaryView.bounds.height
                self.view.layoutIfNeeded()
            }
            ProgressHUD.dismiss()
        }
    }
}

// MARK: - Layout methods

private extension CartViewController {

    func setupView() {
        view.backgroundColor = .white
        
        [summaryView, nftsTableView]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        view.addSubview(summaryView)
        view.addSubview(nftsTableView)
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
            // nftsTableView
            nftsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            nftsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nftsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            nftsTableView.bottomAnchor.constraint(equalTo: summaryView.topAnchor)
        ])
        
        summaryViewTopConstraint = summaryView.topAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        summaryViewTopConstraint?.isActive = true
    }
}

// MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.nfts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartNFTCell = tableView.dequeueReusableCell()
        if let model = viewModel?.nfts[indexPath.row] {
            cell.configure(with: model)
        }
        return cell
    }
}
