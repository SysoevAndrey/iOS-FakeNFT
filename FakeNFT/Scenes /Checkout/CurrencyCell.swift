import UIKit

final class CurrencyCell: UICollectionViewCell {
    // MARK: - Layout elements

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private let imageBackgroundView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 6
        view.backgroundColor = .blackUniversal
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .green
        return label
    }()
    private let labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func configure(with model: CurrencyModel) {
        if let url = URL(string: model.image) {
            imageView.kf.setImage(with: url)
        }
        titleLabel.text = model.title
        nameLabel.text = model.name
    }

    func select() {
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
    }

    func deselect() {
        contentView.layer.borderWidth = 0
    }
}

// MARK: - Layout methods

private extension CurrencyCell {
    func setupView() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .lightGray

        [imageBackgroundView, imageView, labelsStackView]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        contentView.addSubview(imageBackgroundView)
        contentView.addSubview(imageView)
        contentView.addSubview(labelsStackView)
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(nameLabel)

        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            // imageBackgroundView
            imageBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            imageBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageBackgroundView.widthAnchor.constraint(equalToConstant: Constants.imageBackgroundSize),
            imageBackgroundView.heightAnchor.constraint(equalToConstant: Constants.imageBackgroundSize),
            // imageView
            imageView.centerXAnchor.constraint(equalTo: imageBackgroundView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageBackgroundView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            // labelsStackView
            labelsStackView.centerYAnchor.constraint(equalTo: imageBackgroundView.centerYAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: imageBackgroundView.trailingAnchor, constant: 4)
        ])
    }
}

// MARK: - Nested types

private extension CurrencyCell {
    enum Constants {
        static let imageSize: CGFloat = 31.5
        static let imageBackgroundSize: CGFloat = 36
    }
}

// MARK: - ReuseIdentifying

extension CurrencyCell: ReuseIdentifying {}
