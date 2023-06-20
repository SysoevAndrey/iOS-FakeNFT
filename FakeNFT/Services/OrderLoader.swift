import Foundation

protocol OrderLoading {
    func load(completion: @escaping (Result<[NFTModel], Error>) -> Void)
}

struct OrderLoader: OrderLoading {

    // MARK: - Properties
    
    private let networkClient: NetworkClient
    
    // MARK: - Lifecycle
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    // MARK: - Public
    
    func load(completion: @escaping (Result<[NFTModel], Error>) -> Void) {
        let getOrderRequest = GetOrderRequest()
        
        networkClient.send(request: getOrderRequest, type: OrderModel.self) { result in
            switch result {
            case .success(let order):
                var nfts = [NFTModel]()
                var requestsFinished = 0  {
                    didSet {
                        guard requestsFinished == order.nfts.count else { return }
                        if nfts.count != order.nfts.count {
                            completion(.failure(Errors.loadNFTError))
                        } else {
                            completion(.success(nfts))
                        }
                    }
                }
                order.nfts.forEach { nftId in
                    loadNFT(by: nftId) { result in
                        switch result {
                        case .success(let nft):
                            nfts.append(nft)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                        requestsFinished += 1
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private
    
    private func loadNFT(by id: String, completion: @escaping (Result<NFTModel, Error>) -> Void) {
        let getNFTByIdRequest = GetNFTByIdRequest(id: id)
        networkClient.send(request: getNFTByIdRequest, type: NFTModel.self) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Nested types

private extension OrderLoader {
    enum Errors: Error {
        case loadNFTError
    }
}
