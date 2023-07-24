//
//  GetCollectionByIdRequest.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 25.06.2023.
//

import Foundation

struct GetCollectionByIdRequest: NetworkRequest {
    var endpoint: URL? {
        NetworkConstants.baseUrl.appendingPathComponent("/collections/\(id)")
    }
    
    private let id: String
    
    init(id: String) {
        self.id = id
    }
}
