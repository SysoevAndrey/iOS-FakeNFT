import UIKit

protocol PayViewDelegate: AnyObject {
    func didTapPayButton()
    func didTapUserAgreementLink()
}

final class PayView: UIView {
    // MARK: - Layout elements

    private lazy var payButton: Button = {
        let button = Button(title: "Оплатить")
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        return button
    }()
    private let userAgreementLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        return label
    }()
    private lazy var userAgreementLink: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .blue
        label.text = "Пользовательского соглашения"
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapUserAgreementLink))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    private let labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()

    // MARK: - Properties

    weak var delegate: PayViewDelegate?
    var isPayButtonEnabled = false {
        didSet {
            payButton.isEnabled = isPayButtonEnabled
        }
    }

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
    private func didTapPayButton() {
        delegate?.didTapPayButton()
    }

    @objc
    private func didTapUserAgreementLink() {
        delegate?.didTapUserAgreementLink()
    }
}

// MARK: - Layout methods

private extension PayView {
    func setupView() {
        backgroundColor = .lightGray
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        [payButton, labelsStackView]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        addSubview(payButton)
        addSubview(labelsStackView)
        labelsStackView.addArrangedSubview(userAgreementLabel)
        labelsStackView.addArrangedSubview(userAgreementLink)

        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            // payButton
            payButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            payButton.heightAnchor.constraint(equalToConstant: 60),
            // labelsStackView
            labelsStackView.leadingAnchor.constraint(equalTo: payButton.leadingAnchor),
            labelsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            labelsStackView.trailingAnchor.constraint(equalTo: payButton.trailingAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: -16)
        ])
    }
}
