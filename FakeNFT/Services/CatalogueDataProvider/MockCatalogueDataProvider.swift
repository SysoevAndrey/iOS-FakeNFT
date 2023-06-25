//
//  MockCatalogueDataProvider.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 25.06.2023.
//

import Foundation

final class MockCatalogueProvider: CatalogueProviderProtocol {
	func getCollections() -> [CollectionItem] {
		return [
			CollectionItem(imageStringURL: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Beige.png",
						   title: "Beige",
						   count: 11),
			CollectionItem(imageStringURL: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Gray.png",
						   title: "Gray",
						   count: 5),
			CollectionItem(imageStringURL: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Green.png",
						   title: "Green",
						   count: 15)
		]
	}
}
