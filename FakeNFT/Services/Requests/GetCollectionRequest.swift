//
//  GetCollectionRequest.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 25.06.2023.
//

import Foundation

struct GetCollectionsRequest: NetworkRequest {
    var endpoint: URL? {
        ApiConstants.baseURL.appendingPathComponent("/collections")
    }
}
