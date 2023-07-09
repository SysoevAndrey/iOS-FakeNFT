//
//  CatalogueViewModel.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 25.06.2023.
//

import Foundation

final class CollectionListViewModel {
    @Observable private(set) var collections: [Collection] = []
    private let provider: CatalogueProviderProtocol
    
    init(provider: CatalogueProviderProtocol) {
        self.provider = provider
    }
    
    func setFilterByCount() {
        collections = collections.sorted(by: { $0.nfts.count < $1.nfts.count })
    }
    
    func setFilterByName() {
        collections = collections.sorted(by: { $0.name < $1.name })
    }
    
    func getCollections() {
        provider.getCollections { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let collections):
                    self.collections = collections
                case .failure(let error):
                    self.collections = []
                    print(error.localizedDescription)
                }
            }
        }
    }
}
