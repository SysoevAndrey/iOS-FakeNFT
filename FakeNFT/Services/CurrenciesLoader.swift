import Foundation

protocol CurrenciesLoading {
    func load(completion: @escaping (Result<[CurrencyModel], Error>) -> Void)
    func performPayment(with currencyId: String, completion: @escaping (Result<PaymentModel, Error>) -> Void)
}

struct CurrenciesLoader: CurrenciesLoading {
    
    // MARK: - Properties
    
    private let networkClient: NetworkClient
    
    // MARK: - Lifecycle
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    // MARK: - Public
    
    func load(completion: @escaping (Result<[CurrencyModel], Error>) -> Void) {
        let getCurrenciesRequest = GetCurrenciesRequest()
        networkClient.send(request: getCurrenciesRequest, type: [CurrencyModel].self) { result in
            switch result {
            case .success(let currencies):
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func performPayment(with currencyId: String, completion: @escaping (Result<PaymentModel, Error>) -> Void) {
        let getOrderPaymentRequest = GetOrderPaymentRequest(id: currencyId)
        networkClient.send(request: getOrderPaymentRequest, type: PaymentModel.self) { result in
            switch result {
            case .success(let payment):
                completion(.success(payment))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
