import ProgressHUD
import UIKit

final class CartViewController: UIViewController {
    // MARK: - Layout elements

    private lazy var summaryView: SummaryView = {
        let view = SummaryView()
        view.delegate = self
        return view
    }()
    private lazy var nftsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.register(CartNFTCell.self)
        return tableView
    }()
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.text = "Корзина пуста"
        label.isHidden = true
        return label
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

        viewModel = CartViewModel()
        bind()

        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressHUD.show()
        viewModel?.loadCart()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.rightBarButtonItem = nil
        viewModel?.clearCart()
        emptyLabel.isHidden = true
    }

    // MARK: - Actions

    @objc
    private func didTapSortButton() {
        let alert = UIAlertController(
            title: nil,
            message: "Сортировка",
            preferredStyle: .actionSheet
        )
        
        let sortByPriceAction = UIAlertAction(title: "По цене", style: .default) { [weak self] _ in
            self?.viewModel?.sort = .price
        }
        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.viewModel?.sort = .rating
        }
        let sortByNameAction = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            self?.viewModel?.sort = .name
        }
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alert.addAction(sortByPriceAction)
        alert.addAction(sortByRatingAction)
        alert.addAction(sortByNameAction)
        alert.addAction(closeAction)
        
        present(alert, animated: true)
    }

    // MARK: - Private

    private func bind() {
        guard let viewModel = viewModel else { return }

        viewModel.onLoad = { [weak self] in
            guard let self else { return }
            self.summaryView.configure(with: viewModel.summaryInfo)
            UIView.animate(withDuration: 0.3) {
                if viewModel.nfts.isEmpty {
                    self.summaryViewTopConstraint?.constant = 0
                } else {
                    self.summaryViewTopConstraint?.constant = -self.summaryView.bounds.height
                    self.navigationItem.rightBarButtonItem = self.sortButton
                }
                self.view.layoutIfNeeded()
            }
            self.setupTableState()
            self.nftsTableView.reloadData()
            ProgressHUD.dismiss()
        }
    }

    private func setupTableState() {
        guard let viewModel else { return }
        emptyLabel.isHidden = !viewModel.nfts.isEmpty
        nftsTableView.isHidden = viewModel.nfts.isEmpty
    }
}

// MARK: - Layout methods

private extension CartViewController {
    func setupView() {
        view.backgroundColor = .white

        [summaryView, nftsTableView, emptyLabel]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        view.addSubview(summaryView)
        view.addSubview(nftsTableView)
        view.addSubview(emptyLabel)
        setupNavBar()
        setupConstraints()
    }

    func setupNavBar() {
        navigationController?.navigationBar.tintColor = .black
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
            nftsTableView.bottomAnchor.constraint(equalTo: summaryView.topAnchor),
            // emptyLabel
            emptyLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
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
            cell.delegate = self
            cell.configure(with: model)
        }
        return cell
    }
}

// MARK: - SummaryViewDelegate

extension CartViewController: SummaryViewDelegate {
    func didTapCheckoutButton() {
        let checkoutViewController = CheckoutViewController()
        let checkoutViewModel = CheckoutViewModel()
        checkoutViewController.viewModel = checkoutViewModel
        checkoutViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(checkoutViewController, animated: true)
    }
}

// MARK: - CartNFTCellDelegate

extension CartViewController: CartNFTCellDelegate {
    func didTapRemoveButton(on nft: NFTModel) {
        let removeNFTViewController = RemoveNFTViewController()
        removeNFTViewController.delegate = self
        removeNFTViewController.configure(with: nft)
        removeNFTViewController.modalPresentationStyle = .overFullScreen
        removeNFTViewController.modalTransitionStyle = .crossDissolve
        present(removeNFTViewController, animated: true)
    }
}

// MARK: - RemoveNFTViewControllerDelegate

extension CartViewController: RemoveNFTViewControllerDelegate {
    func didTapCancelButton() {
        dismiss(animated: true)
    }

    func didTapConfirmButton(_ model: NFTModel) {
        viewModel?.onDelete(nft: model) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}
