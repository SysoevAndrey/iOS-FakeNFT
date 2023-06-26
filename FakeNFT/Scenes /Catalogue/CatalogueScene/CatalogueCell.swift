//
//  CatalogueCell.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 25.06.2023.
//

import UIKit
import Kingfisher

final class CollectionListCell: UITableViewCell, ReuseIdentifying {
	static var defaultReuseIdentifier: String { "collectionListCell" }
	
	private lazy var coverImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 12
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	
	private lazy var collectionNameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.bodyBold
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		coverImageView.kf.cancelDownloadTask()
	}
	
	private func setupLayout() {
		addSubview(coverImageView)
		addSubview(collectionNameLabel)
		
		NSLayoutConstraint.activate([
			coverImageView.topAnchor.constraint(equalTo: topAnchor),
			coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			coverImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
			coverImageView.heightAnchor.constraint(equalToConstant: 140),
			
			collectionNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			collectionNameLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 4)
		])
		
	}
	
	func config(collectionItem: Collection) {
		let imageURL = URL(string: collectionItem.cover.encodeUrl)
		coverImageView.kf.indicatorType = .activity
		coverImageView.kf.setImage(with: imageURL)
		
		collectionNameLabel.text = "\(collectionItem.name) (\(collectionItem.nfts.count))"
	}
}
