//
//  CatalogueViewModel.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 25.06.2023.
//

import Foundation

final class CollectionListViewModel {
	@Observable var collections: [CollectionItem] = []
	private let provider: CatalogueProviderProtocol
	
	init(provider: CatalogueProviderProtocol) {
		self.provider = provider
		collections = provider.getCollections()
	}
	
	func setFilterByCount() {
		collections = collections.sorted(by: { $0.count > $1.count })
	}
	
	func setFilterByName() {
		collections = collections.sorted(by: { $0.title > $1.title })
	}
}
