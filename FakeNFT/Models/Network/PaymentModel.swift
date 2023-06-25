import Foundation

struct PaymentModel: Codable {
    let id: String
    let orderId: String
    let success: Bool
}
