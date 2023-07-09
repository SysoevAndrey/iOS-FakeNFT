//
//  CatalogueDataProvider.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 25.06.2023.
//

import Foundation

final class CatalogueDataProvider: CatalogueProviderProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func getCollections(completion: @escaping (Result<[Collection], Error>) -> Void) {
        let getCollectionsRequest = GetCollectionsRequest()
        networkClient.send(request: getCollectionsRequest,
                           type: [Collection].self) { result in
            switch result {
            case .success(let collections):
                completion(.success(collections))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
}


