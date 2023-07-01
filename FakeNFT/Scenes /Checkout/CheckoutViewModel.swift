import Foundation

final class CheckoutViewModel {
    // MARK: - Properties

    private(set) var currencies: [CurrencyModel] = [] {
        didSet {
            onLoad?()
        }
    }
    private(set) var selectedCurrency: CurrencyModel? {
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
    private let orderLoader: OrderLoading?

    // MARK: - Lifecycle

    init(
        currenciesLoader: CurrenciesLoading = CurrenciesLoader(),
        orderLoader: OrderLoading = OrderLoader()
    ) {
        self.currenciesLoader = currenciesLoader
        self.orderLoader = orderLoader
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
                    print(error.localizedDescription)
                }
            }
        }
    }

    func selectCurrency(with id: String) {
        selectedCurrency = currencies.first { $0.id == id }
    }

    func performPayment() {
        guard let selectedCurrency else { return }
        currenciesLoader.performPayment(with: selectedCurrency.id) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let payment):
                    if payment.success == true {
                        self.clearCart {
                            self.paymentStatus = .success
                        }
                    } else {
                        self.paymentStatus = .failure
                    }
                case .failure(let error):
                    self.paymentStatus = .failure
                    print(error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Private

    private func clearCart(completion: @escaping () -> Void) {
        orderLoader?.update(with: []) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion()
                case .failure(let error):
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
