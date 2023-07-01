//
//  GetUserByIDRequest.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 01.07.2023.
//

import Foundation

struct GetUserByIdRequest: NetworkRequest {
	private let id: String

	init(id: String) {
		self.id = id
	}

	var endpoint: URL? {
		ApiConstants.baseURL.appendingPathComponent("/users/\(id)")
	}
}
