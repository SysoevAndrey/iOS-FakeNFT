import Foundation

final class CartViewModel {
    
    // MARK: - Properties

    var onLoad: (() -> Void)?
    var summaryInfo: SummaryInfo {
        let price = nfts.reduce(0.0) { $0 + $1.price }
        return SummaryInfo(count: nfts.count, price: price)
    }
    private(set) var nfts: [NFTModel] = [] {
        didSet {
            onLoad?()
        }
    }

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
                    self.nfts = nfts
                case .failure(let error):
                    // TODO: обработать ошибку
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Nested types

extension CartViewModel {
    struct SummaryInfo {
        var count: Int
        var price: Double
    }
}
