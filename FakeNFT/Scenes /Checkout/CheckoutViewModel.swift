import Foundation

final class CheckoutViewModel {
    
    // MARK: - Properties
    
    private(set) var currencies: [CurrencyModel] = [] {
        didSet {
            onLoad?()
        }
    }
    private(set) var selectedCurrency: CurrencyModel? = nil {
        didSet {
            onSelectCurrency?()
        }
    }

    var onLoad: (() -> Void)?
    var onSelectCurrency: (() -> Void)?
    weak var viewController: CartViewController?
    private let currenciesLoader: CurrenciesLoading
    
    // MARK: - Lifecycle
    
    init(currenciesLoader: CurrenciesLoading = CurrenciesLoader()) {
        self.currenciesLoader = currenciesLoader
    }
    
    // MARK: - Public
    
    func loadCurrencies() {
        currenciesLoader.load { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let currencies):
                    self.currencies = currencies
                case .failure(let error):
                    // TODO: обработать ошибку
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func selectCurrency(with id: String) {
        selectedCurrency = currencies.first(where: { $0.id == id })
    }
}
