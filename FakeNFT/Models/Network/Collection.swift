//
//  Collection.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 25.06.2023.
//

import Foundation

struct Collection: Decodable {
    let id: String
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
}
