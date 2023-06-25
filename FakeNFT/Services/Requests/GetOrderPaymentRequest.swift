import Foundation

struct GetOrderPaymentRequest: NetworkRequest {
    private let id: String
    
    init(id: String) {
        self.id = id
    }
    
    var endpoint: URL? {
        NetworkConstants.baseUrl.appendingPathComponent("/orders/1/payment/\(id)")
    }
}
