//
//  GetCollectionByIdRequest.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 25.06.2023.
//

import Foundation

struct GetCollectionByIdRequest: NetworkRequest {
	private let id: String
	
	init(id: String) {
		self.id = id
	}
	
	var endpoint: URL? {
		ApiConstants.baseURL.appendingPathComponent("/collections")
	}
	
	var queryParameters: [String: String]? {
		["id" : id]
	}
}
