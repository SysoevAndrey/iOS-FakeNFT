//
//  CollectionViewModel.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 28.06.2023.
//

import Foundation

final class CollectionViewModel {
    var numberOfItems: Int {
        nftItems.count
    }
    
    let collectionModel: Collection
    let collectionDataProvider: CollectionDataProviderProtocol
    
    @Observable private(set) var nftItems: [NFTViewModel] = []
    @Observable private(set) var authorModel: AuthorModel = AuthorModel(id: "", name: "", website: "")
    @Observable private(set) var loadingInProgress: Bool = false
    @Observable private(set) var mainLoadErrorDescription: String = ""
    @Observable private(set) var addToCartErrorDescription: String = ""
    @Observable private(set) var addToFavoritesErrorDescription: String = ""
    
    private var orderItems: [String] = []
    private var likedItems: [String] = []
    
    init(collectionModel: Collection, collectionDataProvider: CollectionDataProviderProtocol = CollectionDataProvider()) {
        self.collectionDataProvider = collectionDataProvider
        self.collectionModel = collectionModel
    }
    
    func loadNFTForCollection() {
        loadingInProgress = true
        
        collectionDataProvider.getOrder { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let orderModel):
                    self.orderItems = orderModel.nfts
                case .failure(let error):
                    self.mainLoadErrorDescription = error.localizedDescription
                }
            }
        }
        
        collectionDataProvider.getFavorites { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let favoritesModel):
                    self.likedItems = favoritesModel.likes
                case .failure(let error):
                    self.mainLoadErrorDescription = error.localizedDescription
                }
            }
        }
        
        let group = DispatchGroup()
        collectionModel.nfts.forEach { id in
            group.enter()
            collectionDataProvider.getNFT(by: id, completion: { [weak self] result in
                guard let self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let nftModel):
                        if let nftViewModel = self.convertToViewModel(from: nftModel) {
                            self.nftItems.append(nftViewModel)
                            group.leave()
                        }
                    case .failure(let error):
                        self.loadingInProgress = false
                        self.mainLoadErrorDescription = error.localizedDescription
                        group.leave()
                    }
                }
            })
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.loadingInProgress = false
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
                            isOrdered: isNFTordered,
                            isLiked: isNFTLiked)
    }
    
    private func replaceNFT(nft: NFTViewModel, isLiked: Bool, isOrdered: Bool) {
        guard let itemIndex = nftItems.firstIndex(where: { $0.id == nft.id }) else { return }
        nftItems[itemIndex] = NFTViewModel(id: nft.id,
                                           name: nft.name,
                                           imageURL: nft.imageURL,
                                           rating: nft.rating,
                                           price: nft.price,
                                           isOrdered: isOrdered,
                                           isLiked: isLiked)
        
    }
    
    func getAuthorURL() {
        collectionDataProvider.getAuthor(by: collectionModel.author) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let authorModel):
                    self.authorModel = authorModel
                case .failure(let error):
                    self.mainLoadErrorDescription = error.localizedDescription
                }
            }
        }
    }
    
    func onAddToCart(indexPath: IndexPath) {
        let orderItemsBeforeAdding = orderItems
        
        let nftItem = nftItems[indexPath.row]
        if nftItem.isOrdered {
            guard let itemIndex = orderItems.firstIndex(of: nftItem.id) else { return }
            orderItems.remove(at: itemIndex)
        } else {
            orderItems.append(nftItem.id)
        }
        
        loadingInProgress = true
        collectionDataProvider.updateOrder(with: orderItems) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self.replaceNFT(nft: nftItem, isLiked: nftItem.isLiked, isOrdered: !nftItem.isOrdered)
                    self.loadingInProgress = false
                    break
                case .failure(let error):
                    self.orderItems = orderItemsBeforeAdding
                    self.loadingInProgress = false
                    self.addToCartErrorDescription = error.localizedDescription
                }
            }
        }
    }
    
    func onAddToFavorites(indexPath: IndexPath) {
        let favoritesBeforeAdding = likedItems
        
        let nftItem = nftItems[indexPath.row]
        if nftItem.isLiked {
            guard let itemIndex = likedItems.firstIndex(of: nftItem.id) else { return }
            likedItems.remove(at: itemIndex)
        } else {
            likedItems.append(nftItem.id)
        }
        
        loadingInProgress = true
        collectionDataProvider.updateFavorites(with: likedItems) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self.replaceNFT(nft: nftItem, isLiked: !nftItem.isLiked, isOrdered: nftItem.isOrdered)
                    self.loadingInProgress = false
                case .failure(let error):
                    self.likedItems = favoritesBeforeAdding
                    self.loadingInProgress = false
                    self.addToFavoritesErrorDescription = error.localizedDescription
                }
            }
        }
    }
}
