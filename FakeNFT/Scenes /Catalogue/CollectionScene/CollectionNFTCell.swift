//
//  CollectionNFTCell.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 28.06.2023.
//

import UIKit
import Kingfisher

protocol CollectionNFTCellDelegate: AnyObject {
	func nftCellDidTapLike(_ cell: CollectionNFTCell)
	func nftCellAddToCart(_ cell: CollectionNFTCell)
}

final class CollectionNFTCell: UICollectionViewCell, ReuseIdentifying {
	weak var delegate: CollectionNFTCellDelegate?
	
	private lazy var nftImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.layer.masksToBounds = true
		imageView.layer.cornerRadius = 12
		return imageView
	}()
	
	private lazy var heartButton: UIButton = {
		let heartButton = UIButton(type: .custom)
		heartButton.setImage(UIImage.Icons.likeNotActive, for: .normal)
		heartButton.addTarget(self, action: #selector(didTapHeartButton), for: .touchUpInside)
		return heartButton
	}()
	
	private lazy var ratingStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.spacing = 2
		return stackView
	}()
	
	private lazy var nftLabel: UILabel = {
		let label = UILabel()
		label.font = .bodyBold
		label.numberOfLines = 0
		return label
	}()
	
	private let priceValue: UILabel = {
		let label = UILabel()
		label.font = .medium10
		return label
	}()
	
	private lazy var nameAndPriceVerticalStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 4
		stackView.alignment = .leading
		stackView.addArrangedSubview(nftLabel)
		stackView.addArrangedSubview(priceValue)
		return stackView
	}()
	
	private lazy var cartButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setImage(UIImage.Icons.trash, for: .normal)
		button.addTarget(self, action: #selector(didTapCartButton), for: .touchUpInside)
		return button
	}()
	
	private lazy var priceAndCartButtonHorizontalStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.distribution = .fill
		stackView.addArrangedSubview(nameAndPriceVerticalStackView)
		stackView.addArrangedSubview(cartButton)
		return stackView
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configure(with model: NFTViewModel, delegate: CollectionNFTCellDelegate) {
		self.delegate = delegate
		
		nftImageView.kf.setImage(with: model.imageURL)
		nftLabel.text = model.name
		priceValue.text = "\(model.price) ETH"

		for star in 0..<model.rating {
			ratingStackView.arrangedSubviews[star].tintColor = .yellow
		}
		
		if model.inOrdered {
			cartButton.setImage(UIImage.Icons.trash, for: .normal)
		} else {
			cartButton.setImage(UIImage.Icons.addToCart, for: .normal)
		}
		
		if model.isLiked {
			heartButton.setImage(UIImage.Icons.likeActive, for: .normal)
		} else {
			heartButton.setImage(UIImage.Icons.likeNotActive, for: .normal)
		}
	}

	@objc
	private func didTapCartButton() {
		delegate?.nftCellAddToCart(self)
	}
	
	@objc
	private func didTapHeartButton() {
		delegate?.nftCellDidTapLike(self)
	}
}

private extension CollectionNFTCell {
	func setupView() {
		contentView.backgroundColor = .white

		[nftImageView, heartButton, ratingStackView, priceAndCartButtonHorizontalStackView].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			contentView.addSubview($0)
		}
		
		for _ in 0..<5 {
			let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
			starImageView.tintColor = .lightGray
			NSLayoutConstraint.activate([
				starImageView.widthAnchor.constraint(equalToConstant: 12),
				starImageView.heightAnchor.constraint(equalToConstant: 12)
			])
			ratingStackView.addArrangedSubview(starImageView)
		}
		setupConstraints()
	}

	func setupConstraints() {
		NSLayoutConstraint.activate([
			nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			nftImageView.heightAnchor.constraint(equalToConstant: 108),
			
			heartButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
			heartButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
			heartButton.heightAnchor.constraint(equalToConstant: 42),
			heartButton.widthAnchor.constraint(equalToConstant: 42),
			
			ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			ratingStackView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
			
			priceAndCartButtonHorizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			priceAndCartButtonHorizontalStackView.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 4),
		])
	}
}
