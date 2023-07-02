//
//  CollectionViewModel.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 28.06.2023.
//

import Foundation

final class CollectionViewModel {
	@Observable private(set) var nftItems: [NFTViewModel] = []
	@Observable private(set) var orderItems: [String] = []
	@Observable private(set) var likedItems: [String] = []
	@Observable private(set) var authorModel: AuthorModel = AuthorModel(id: "", name: "", website: "")
	@Observable private(set) var loadingInProgress: Bool = false
	
	private let collectionDataProvider: CollectionDataProviderProtocol

	init(collectionDataProvider: CollectionDataProviderProtocol = CollectionDataProvider()) {
		self.collectionDataProvider = collectionDataProvider
	}
	
	func loadNFTForCollection(collection: Collection) {
		loadingInProgress = true
		var countNFTDidLoad = 0
		
		collection.nfts.forEach { id in
			collectionDataProvider.getNFT(by: id, completion: { [weak self] result in
				guard let self else { return }
				DispatchQueue.main.async {
					switch result {
					case .success(let nftModel):
						if let nftViewModel = self.convertToViewModel(from: nftModel) {
							self.nftItems.append(nftViewModel)
							
							countNFTDidLoad += 1
							if countNFTDidLoad == collection.nfts.count {
								self.loadingInProgress = false
							}
						}
					case .failure(let error):
						print(error.localizedDescription)
					}
				}
			})
		}
	}
	
	private func convertToViewModel(from nftModel: NFTModel) -> NFTViewModel? {
		guard let image = nftModel.images.first,
			  let imageURL = URL(string: image) else { return nil }
		
		let isNFTordered = orderItems.contains(nftModel.id)
		let isNFTLiked = likedItems.contains(nftModel.id)
		
		return NFTViewModel(id: nftModel.id,
							name: nftModel.name,
							imageURL: imageURL,
							rating: nftModel.rating,
							price: nftModel.price,
							inOrdered: isNFTordered,
							isLiked: isNFTLiked)
	}
	
	func getAuthorURL(collection: Collection) {
		collectionDataProvider.getAuthor(by: collection.author) { [weak self] result in
			guard let self else { return }
			DispatchQueue.main.async {
				switch result {
				case .success(let authorModel):
					self.authorModel = authorModel
				case .failure(let error):
					print(error.localizedDescription)
				}
			}
		}
	}
	
	func getOrder() {
		collectionDataProvider.getOrder { [weak self] result in
			guard let self else { return }
			DispatchQueue.main.async {
				switch result {
				case .success(let orderModel):
					self.orderItems = orderModel.nfts
				case .failure(let error):
					print(error.localizedDescription)
				}
			}
		}
	}
	
	func getFavorites(collection: Collection) {
		//loadingInProgress = true
		collectionDataProvider.getFavorites { [weak self] result in
			guard let self else { return }
//			DispatchQueue.main.async {
//				switch result {
//				case .success(let orderModel):
//					self.orderItems = orderModel.nfts
//					self.loadingInProgress = false
//				case .failure(let error):
//					print(error.localizedDescription)
//					self.loadingInProgress = false
//				}
//			}
		}
	}

	func addToCart(nftViewModel: NFTViewModel) {
		let orderItemsBeforeAdding = orderItems
		
		if nftViewModel.inOrdered {
			guard let itemIndex = orderItems.firstIndex(of: nftViewModel.id) else { return }
			orderItems.remove(at: itemIndex)
		} else {
			orderItems.append(nftViewModel.id)
		}
		
		loadingInProgress = true
		collectionDataProvider.updateOrder(with: orderItems) { [weak self] result in
			guard let self else { return }
			DispatchQueue.main.async {
				switch result {
				case .success():
					self.loadingInProgress = false
					break
				case .failure(let error):
					self.orderItems = orderItemsBeforeAdding
					self.loadingInProgress = false
					print(error.localizedDescription)
				}
			}
		}
	}
	
	func addToFavorites(nftViewModel: NFTViewModel) {
		let favoritesBeforeAdding = likedItems
		
		if nftViewModel.isLiked {
			guard let itemIndex = likedItems.firstIndex(of: nftViewModel.id) else { return }
			likedItems.remove(at: itemIndex)
		} else {
			likedItems.append(nftViewModel.id)
		}
		
		//loadingInProgress = true
	}
}
