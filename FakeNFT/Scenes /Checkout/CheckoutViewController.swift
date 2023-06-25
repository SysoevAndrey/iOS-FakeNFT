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

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Layout methods

private extension CheckoutViewController {

    func setupView() {
        view.backgroundColor = .white
        
        [payView]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        view.addSubview(payView)
        
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
        ])
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
