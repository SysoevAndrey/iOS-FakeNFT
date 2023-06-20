import Foundation

final class CartViewModel {
    
    // MARK: - Properties
    
    private(set) var summaryInfo = SummaryInfo(count: 0, price: 0) {
        didSet {
            onChange?()
        }
    }

    var onChange: (() -> Void)?
    private let orderLoader: OrderLoading
    private weak var viewController: CartViewController?
    
    // MARK: - Lifecycle
    
    init(viewController: CartViewController, orderLoader: OrderLoading = OrderLoader()) {
        self.viewController = viewController
        self.orderLoader = orderLoader
    }
    
    // MARK: - Public
    
    func viewDidLoad() {
        orderLoader.load { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let nfts):
                    self.summaryInfo = self.obtainSummaryInfo(of: nfts)
                case .failure(let error):
                    // TODO: обработать ошибку
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Private
    
    private func obtainSummaryInfo(of nfts: [NFTModel]) -> SummaryInfo {
        let price = nfts.reduce(0.0) { $0 + $1.price }
        return SummaryInfo(count: nfts.count, price: price)
    }
}

// MARK: - Nested types

extension CartViewModel {
    struct SummaryInfo {
        var count: Int
        var price: Double
    }
}
