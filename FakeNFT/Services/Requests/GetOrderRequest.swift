import Foundation

struct GetOrderRequest: NetworkRequest {
    var endpoint: URL? {
        NetworkConstants.baseUrl.appendingPathComponent("/orders/1")
    }
}
