import UIKit

protocol SummaryViewDelegate: AnyObject {
    func didTapCheckoutButton()
}

final class SummaryView: UIView {
    
    // MARK: - Layout elements
    
    private lazy var checkoutButton: Button = {
        let button = Button(title: "К оплате")
        button.addTarget(self, action: #selector(didTapCheckoutButton), for: .touchUpInside)
        return button
    }()
    private let labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.text = "0 NFT"
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .green
        label.text = "0 ETH"
        return label
    }()
    
    // MARK: - Properties
    
    weak var delegate: SummaryViewDelegate?
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapCheckoutButton() {
        delegate?.didTapCheckoutButton()
    }
    
    // MARK: - Public
    
    func configure(with summaryInfo: CartViewModel.SummaryInfo) {
        countLabel.text = "\(summaryInfo.count) NFT"
        priceLabel.text = "\(String(format:"%.2f", summaryInfo.price)) ETH"
    }
}

// MARK: - Layout methods

private extension SummaryView {

    func setupView() {
        backgroundColor = .lightGray
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        [checkoutButton, labelsStack]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        addSubview(checkoutButton)
        addSubview(labelsStack)
        labelsStack.addArrangedSubview(countLabel)
        labelsStack.addArrangedSubview(priceLabel)
        
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            // labelsStack
            labelsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelsStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            labelsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            // checkoutButton
            checkoutButton.leadingAnchor.constraint(equalTo: labelsStack.trailingAnchor, constant: 24),
            checkoutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            checkoutButton.centerYAnchor.constraint(equalTo: labelsStack.centerYAnchor),
            checkoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
