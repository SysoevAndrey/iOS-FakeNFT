import Foundation

struct GetCurrenciesRequest: NetworkRequest {
    var endpoint: URL? {
        NetworkConstants.baseUrl.appendingPathComponent("/currencies")
    }
}
