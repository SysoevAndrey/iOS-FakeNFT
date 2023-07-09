//
//  MockCatalogueDataProvider.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 25.06.2023.
//

import Foundation

final class MockCatalogueProvider: CatalogueProviderProtocol {
    func getCollections(completion: @escaping (Result<[Collection], Error>) -> Void) {
        let collections = [
            Collection(id: "1",
                       createdAt: "",
                       name: "Beige",
                       cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Beige.png",
                       nfts: ["1","3","5"],
                       description: "Description",
                       author: "2"),
            Collection(id: "2",
                       createdAt: "",
                       name: "Gray",
                       cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Gray.png",
                       nfts: ["1","3","5","7","9"],
                       description: "Description",
                       author: "7"),
            Collection(id: "1",
                       createdAt: "",
                       name: "Green",
                       cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Green.png",
                       nfts: ["7","9","2","8"],
                       description: "Description",
                       author: "8")
        ]
        
        completion(.success(collections))
    }
}
