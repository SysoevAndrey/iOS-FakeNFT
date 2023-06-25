//
//  CatalogueDataProviderProtocol.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 25.06.2023.
//

import Foundation

protocol CatalogueProviderProtocol {
	func getCollections() -> [CollectionItem]
}
