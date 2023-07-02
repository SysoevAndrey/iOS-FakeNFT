//
//  NFTViewModel.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 01.07.2023.
//

import Foundation

struct NFTViewModel {
	let id: String
	let name: String
	let imageURL: URL
	let rating: Int
	let price: Double
	let isOrdered: Bool
	let isLiked: Bool
}
