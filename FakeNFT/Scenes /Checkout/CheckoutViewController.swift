import UIKit

final class CheckoutViewController: UIViewController {
    
    // MARK: - Layout elements

    private lazy var payView: PayView = {
        let view = PayView()
        view.delegate = self
        return view
    }()
    private lazy var backButton = UIBarButtonItem(
        image: UIImage.Icons.back,
        style: .plain,
        target: self,
        action: #selector(didTapBackButton)
    )
    private lazy var currenciesCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = .clear
        collection.dataSource = self
        collection.delegate = self
        collection.allowsMultipleSelection = false
        collection.register(CurrencyCell.self)
        return collection
    }()
    
    // MARK: - Properties
    
    var viewModel: CheckoutViewModel?
    private let collectionConfig = UICollectionView.Config(
        cellCount: 2,
        leftInset: 16,
        rightInset: 16,
        topInset: 0,
        bottomInset: 0,
        height: 46,
        cellSpacing: 8
    )

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.loadCurrencies()
        bind()
        
        setupView()
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private
    
    private func bind() {
        guard let viewModel else { return }
        
        viewModel.onLoad = { [weak self] in
            self?.currenciesCollection.reloadData()
        }
        
        viewModel.onSelectCurrency = { [weak self] in
            self?.payView.isPayButtonEnabled = viewModel.selectedCurrency != nil
        }
    }
}

// MARK: - Layout methods

private extension CheckoutViewController {

    func setupView() {
        view.backgroundColor = .white
        
        [payView, currenciesCollection]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        view.addSubview(payView)
        view.addSubview(currenciesCollection)
        
        setupNavBar()
        setupConstraints()
    }

    func setupNavBar() {
        title = "Выберите способ оплаты"
        
        navigationItem.leftBarButtonItem = backButton
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // payView
            payView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            payView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            payView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            // currenciesCollection
            currenciesCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            currenciesCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            currenciesCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            currenciesCollection.bottomAnchor.constraint(equalTo: payView.topAnchor),
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension CheckoutViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel?.currencies.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: CurrencyCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        if let model = viewModel?.currencies[indexPath.row] {
            cell.configure(with: model)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CheckoutViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableSpace = collectionView.frame.width - collectionConfig.paddingWidth
        let cellWidth = availableSpace / collectionConfig.cellCount
        return CGSize(width: cellWidth, height: collectionConfig.height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: collectionConfig.topInset,
            left: collectionConfig.leftInset,
            bottom: collectionConfig.bottomInset,
            right: collectionConfig.rightInset
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        collectionConfig.cellSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        collectionConfig.cellSpacing
    }
}

// MARK: - UICollectionViewDelegate

extension CheckoutViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: CurrencyCell = collectionView.cellForItem(at: indexPath)
        if let model = viewModel?.currencies[indexPath.row] {
            viewModel?.selectCurrency(with: model.id)
            cell.select()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell: CurrencyCell = collectionView.cellForItem(at: indexPath)
        cell.deselect()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension CheckoutViewController: UIGestureRecognizerDelegate {}

// MARK: - PayViewDelegate

extension CheckoutViewController: PayViewDelegate {

    func didTapPayButton() {
        // TODO: pay
    }
    
    func didTapUserAgreementLink() {
        let userAgreementViewController = UserAgreementViewController()
        navigationController?.pushViewController(userAgreementViewController, animated: true)
    }
}
