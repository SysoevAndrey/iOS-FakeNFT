//
//  CollectionDataProvaderProtocol.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 02.07.2023.
//

import Foundation

protocol CollectionDataProviderProtocol {
    func getOrder(completion: @escaping (Result<OrderModel, Error>) -> Void)
    func updateOrder(with nftIds: [String], completion: @escaping (Result<Void, Error>) -> Void)
    func getNFT(by id: String, completion: @escaping (Result<NFTModel, Error>) -> Void)
    func getAuthor(by id: String, completion: @escaping (Result<AuthorModel, Error>) -> Void)
    func getFavorites(completion: @escaping (Result<FavoritesModel, Error>) -> Void)
    func updateFavorites(with favoritesIDs: [String], completion: @escaping (Result<Void, Error>) -> Void)
}
