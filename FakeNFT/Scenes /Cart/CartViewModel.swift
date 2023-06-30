import Foundation

final class CartViewModel {
    // MARK: - Properties

    var onLoad: (() -> Void)?
    var summaryInfo: SummaryInfo {
        let price = nfts.reduce(0.0) { $0 + $1.price }
        return SummaryInfo(count: nfts.count, price: price)
    }
    var sort: Sort? {
        didSet {
            guard let sort else {
                nfts = fetchedNfts
                return
            }
            nfts = applySort(by: sort)
        }
    }
    private(set) var nfts: [NFTModel] = [] {
        didSet {
            onLoad?()
        }
    }

    private let orderLoader: OrderLoading
    private weak var viewController: CartViewController?
    private var fetchedNfts: [NFTModel] = []

    // MARK: - Lifecycle

    init(viewController: CartViewController, orderLoader: OrderLoading = OrderLoader()) {
        self.viewController = viewController
        self.orderLoader = orderLoader
    }

    // MARK: - Public

    func loadCart() {
        orderLoader.load { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let nfts):
                    self.fetchedNfts = nfts
                    self.nfts = nfts
                case .failure(let error):
                    // TODO: обработать ошибку
                    self.nfts = []
                    print(error.localizedDescription)
                }
            }
        }
    }

    func clearCart() {
        nfts = []
    }

    func onDelete(nft: NFTModel, completion: @escaping () -> Void) {
        let updatedIdsArray = nfts
            .filter { $0.id != nft.id }
            .map { $0.id }

        orderLoader.update(with: updatedIdsArray) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let nfts):
                    self.nfts = self.nfts.filter { nfts.contains($0.id) }
                case .failure(let error):
                    // TODO: обработать ошибку
                    print(error.localizedDescription)
                }
                completion()
            }
        }
    }
    
    // MARK: - Private
    
    private func applySort(by value: Sort) -> [NFTModel] {
        switch value {
        case .price:
            return fetchedNfts.sorted(by: { $0.price < $1.price })
        case .rating:
            return fetchedNfts.sorted(by: { $0.rating < $1.rating })
        case .name:
            return fetchedNfts.sorted(by: { $0.name < $1.name })
        }
    }
}

// MARK: - Nested types

extension CartViewModel {

    struct SummaryInfo {
        var count: Int
        var price: Double
    }
    
    enum Sort {
        case price
        case rating
        case name
    }
}
