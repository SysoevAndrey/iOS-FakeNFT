//
//  GetFavoritesRequest.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 02.07.2023.
//

import Foundation

struct GetFavoritesRequest: NetworkRequest {
    var endpoint: URL? {
        ApiConstants.baseURL.appendingPathComponent("/profile/1")
    }
}
