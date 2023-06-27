import Foundation

struct PaymentModel: Decodable {
    let id: String
    let orderId: String
    let success: Bool
}
