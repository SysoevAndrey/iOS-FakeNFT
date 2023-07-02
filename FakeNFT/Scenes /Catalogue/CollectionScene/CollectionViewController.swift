//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 01.07.2023.
//

import UIKit
import Kingfisher

final class CollectionViewController: UIViewController, UIGestureRecognizerDelegate {
	private lazy var backButton = UIBarButtonItem(
		image: UIImage.Icons.back,
		style: .plain,
		target: self,
		action: #selector(didTapBackButton)
	)
	
	private lazy var coverImage: UIImageView = {
		let imageView = UIImageView()
		imageView.layer.cornerRadius = 16
		imageView.clipsToBounds = true
		imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
		return imageView
	}()
	
	private lazy var collectionNameLabel: UILabel = {
		let label = UILabel()
		label.font = .bold22
		return label
	}()
	
	private lazy var authorLink: UILabel = {
		let label = UILabel()
		label.font = .caption1
		label.textColor = .blue
		label.isUserInteractionEnabled = true
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAuthorLink))
		label.addGestureRecognizer(tapGesture)
		return label
	}()
	
	private lazy var authorTitle: UILabel = {
		let label = UILabel()
		label.font = .caption2
		label.text = "Автор коллекции:"
		return label
	}()
	
	private let authorHorizontalStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .firstBaseline
		stackView.spacing = 4
		return stackView
	}()
	
	private lazy var nftDescriptionLabel: UILabel = {
		let label = UILabel()
		label.font = .caption2
		label.numberOfLines = 0
		return label
	}()
	
	private let fullDescriptionVerticalStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .leading
		stackView.spacing = 5
		return stackView
	}()

	private lazy var nftCollectionView: UICollectionView = {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
		collection.backgroundColor = .clear
		collection.dataSource = self
		collection.delegate = self
		collection.allowsMultipleSelection = false
		collection.register(CollectionNFTCell.self)
		return collection
	}()
	
	private lazy var contentView: UIView = {
		let contentView = UIView()
		return contentView
	}()

	private var nftCollectionModel: Collection?
	private var viewModel: CollectionViewModel?
	
	private let collectionConfig = UICollectionView.Config(
		cellCount: 3,
		leftInset: 16,
		rightInset: 16,
		topInset: 0,
		bottomInset: 0,
		height: 192,
		cellSpacing: 8
	)

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		bindViewModel()
		setupValuesForUIElements()
		
		guard let collection = nftCollectionModel else { return }
		viewModel?.loadNFTForCollection(collection: collection)
		viewModel?.getAuthorURL(collection: collection)
	}
	
	func initialise(viewModel: CollectionViewModel, model: Collection) {
		self.viewModel = viewModel
		self.nftCollectionModel = model
	}

	@objc
	private func didTapBackButton() {
		navigationController?.popViewController(animated: true)
	}
	
	@objc
	private func didTapAuthorLink() {
		let aboutAuthorScreen = AboutAuthorViewController()
		aboutAuthorScreen.modalPresentationStyle = .fullScreen
		aboutAuthorScreen.inialise(authorPageURL: viewModel?.authorModel.website ?? "")
		
		navigationController?.pushViewController(aboutAuthorScreen, animated: true)
	}

	private func bindViewModel() {
		guard let viewModel else { return }

		viewModel.$nftItems.bind { [weak self] _ in
			guard let self = self else { return }
			self.nftCollectionView.reloadData()
		}
		
		viewModel.$loadingInProgress.bind { _ in
			if viewModel.loadingInProgress {
				UIBlockingProgressHUD.show()
			} else {
				UIBlockingProgressHUD.dismiss()
			}
		}
		
		viewModel.$authorModel.bind { [weak self] _ in
			guard let self = self else { return }
			self.authorLink.text = viewModel.authorModel.name
		}
	}
}

private extension CollectionViewController {
	func setupView() {
		view.backgroundColor = .white

		[coverImage, collectionNameLabel, fullDescriptionVerticalStackView, nftCollectionView].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		}
		authorHorizontalStackView.addArrangedSubview(authorTitle)
		authorHorizontalStackView.addArrangedSubview(authorLink)
		
		fullDescriptionVerticalStackView.addArrangedSubview(authorHorizontalStackView)
		fullDescriptionVerticalStackView.addArrangedSubview(nftDescriptionLabel)
		
		setupNavBar()
		setupConstraints()
	}
	
	func setupValuesForUIElements() {
		let coverURL = URL(string: nftCollectionModel?.cover.encodeUrl ?? "")
		coverImage.kf.setImage(with: coverURL)
		
		collectionNameLabel.text = nftCollectionModel?.name
		authorLink.text = viewModel?.authorModel.name
		nftDescriptionLabel.text = nftCollectionModel?.description
	}

	func setupNavBar() {
		navigationItem.leftBarButtonItem = backButton
		navigationController?.navigationBar.tintColor = .black
		navigationController?.interactivePopGestureRecognizer?.delegate = self
	}

	func setupConstraints() {
		NSLayoutConstraint.activate([
			coverImage.topAnchor.constraint(equalTo: view.topAnchor),
			coverImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			coverImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			coverImage.heightAnchor.constraint(equalToConstant: 310),
			
			collectionNameLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 16),
			collectionNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			
			fullDescriptionVerticalStackView.topAnchor.constraint(equalTo: collectionNameLabel.bottomAnchor, constant: 8),
			fullDescriptionVerticalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			fullDescriptionVerticalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			
			nftCollectionView.topAnchor.constraint(equalTo: fullDescriptionVerticalStackView.bottomAnchor, constant: 24),
			nftCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			nftCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			nftCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}
}

extension CollectionViewController: CollectionNFTCellDelegate {
	func nftCellDidTapLike(_ cell: CollectionNFTCell) {
		guard let indexPath = nftCollectionView.indexPath(for: cell) else { return }
		guard let nftItem = viewModel?.nftItems[indexPath.row] else { return }
		
		viewModel?.addToFavorites(nftViewModel: nftItem)
	}
	
	func nftCellAddToCart(_ cell: CollectionNFTCell) {
		guard let indexPath = nftCollectionView.indexPath(for: cell) else { return }
		guard let nftItem = viewModel?.nftItems[indexPath.row] else { return }
		
		viewModel?.addToCart(nftViewModel: nftItem)
	}
}

extension CollectionViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		viewModel?.nftItems.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: CollectionNFTCell = collectionView.dequeueReusableCell(indexPath: indexPath)
		if let model = viewModel?.nftItems[indexPath.row] {
			cell.configure(with: model, delegate: self)
		}
		return cell
	}
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
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

