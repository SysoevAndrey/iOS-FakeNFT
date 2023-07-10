//
//  CatalogueViewModel.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 25.06.2023.
//

import Foundation

final class CollectionListViewModel {
    @Observable private(set) var collections: [Collection] = []
    @Observable private(set) var errorDescription: String = ""
    
    private var sort: SortType? {
        didSet {
            guard let sort = sort else { return }
            applySort(by: sort)
            settingsManager.sortCollectionsType = sort.rawValue
        }
    }
    
    private let provider: CatalogueProviderProtocol
    private let settingsManager = SettingsManager.shared
    
    init(provider: CatalogueProviderProtocol) {
        self.provider = provider
    }
    
    func getCollections() {
        provider.getCollections { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let collections):
                    self.collections = collections
                    
                    if let sortType = self.settingsManager.sortCollectionsType {
                        self.setSortType(sortType: SortType.getTypeByString(stringType: sortType))
                    }
                case .failure(let error):
                    self.collections = []
                    self.errorDescription = error.localizedDescription
                }
            }
        }
    }
    
    func setSortType(sortType: SortType) {
        self.sort = sortType
    }
    
    private func applySort(by value: SortType) {
        switch value {
        case .sortByCount:
            setFilterByCount()
        case .sortByName:
            setFilterByName()
        }
    }
    
    private func setFilterByCount() {
        collections = collections.sorted(by: { $0.nfts.count < $1.nfts.count })
    }
    
    private func setFilterByName() {
        collections = collections.sorted(by: { $0.name < $1.name })
    }
}
