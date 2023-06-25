import UIKit

final class ResultsViewController: UIViewController {

    // MARK: - Layout elements
    
    private let imageView = UIImageView()
    private let label: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    private lazy var button: Button = {
        let button = Button(title: "")
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    private var buttonAction: (() -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapButton() {
        buttonAction?()
    }
    
    // MARK: - Public
    
    func configure(with content: Content) {
        imageView.image = content.image
        label.text = content.title
        button.setTitle(content.buttonTitle, for: .normal)
        buttonAction = content.buttonAction
    }
}

// MARK: - Layout methods

private extension ResultsViewController {
    
    func setupView() {
        view.backgroundColor = .white
        
        [stackView, imageView, button]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        view.addSubview(button)
        
        setupNavBar()
        setupConstraints()
    }
    
    func setupNavBar() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.hidesBackButton = true
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // stackView
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 26),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            // imageView
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            // button
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

// MARK: - Nested types

extension ResultsViewController {
    
    struct Content {
        let image: UIImage?
        let title: String
        let buttonTitle: String
        let buttonAction: () -> Void
    }
    
    struct Constants {
        static let imageSize: CGFloat = 278
    }
}
