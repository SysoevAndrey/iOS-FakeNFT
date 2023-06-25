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
    private(set) var paymentStatus: PaymentStatus = .notPay {
        didSet {
            onPay?()
        }
    }

    var onLoad: (() -> Void)?
    var onSelectCurrency: (() -> Void)?
    var onPay: (() -> Void)?
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
    
    func performPayment() {
        guard let selectedCurrency else { return }
        currenciesLoader.performPayment(with: selectedCurrency.id) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let payment):
                    self.paymentStatus = payment.success ? .success : .failure
                case .failure(let error):
                    // TODO: обработать ошибку
                    self.paymentStatus = .failure
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension CheckoutViewModel {
    enum PaymentStatus {
        case notPay, success, failure
    }
}
