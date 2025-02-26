import Foundation

final class CartViewModel {
    // MARK: - Properties

    var onLoad: (() -> Void)?
    var onLoadingChange: (() -> Void)?
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
    private(set) var isLoading = false {
        didSet {
            onLoadingChange?()
        }
    }
    private(set) var nfts: [NFTModel] = [] {
        didSet {
            onLoad?()
        }
    }

    private let orderLoader: OrderLoading
    private var fetchedNfts: [NFTModel] = [] {
        didSet {
            nfts = fetchedNfts
        }
    }

    // MARK: - Lifecycle

    init(orderLoader: OrderLoading = OrderLoader()) {
        self.orderLoader = orderLoader
    }

    // MARK: - Public

    func loadCart() {
        isLoading = true
        orderLoader.load { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let nfts):
                    self.fetchedNfts = nfts
                case .failure(let error):
                    self.nfts = []
                    print(error.localizedDescription)
                }
                self.isLoading = false
            }
        }
    }

    func clearCart() {
        nfts = []
    }

    func onDelete(nft: NFTModel, completion: @escaping () -> Void) {
        isLoading = true
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
                    print(error.localizedDescription)
                }
                self.isLoading = false
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
