import Foundation

struct GetItemByIdRequest: NetworkRequest {
    private let id: String
    private let item: ItemType
    
    init(id: String, item: ItemType) {
        self.id = id
        self.item = item
    }
    
    var endpoint: URL? {
        if item == .author {
            return NetworkConstants.baseUrl.appendingPathComponent("/users/\(id)")
        } else {
            return NetworkConstants.baseUrl.appendingPathComponent("/nft/\(id)")
        }
    }
}

enum ItemType {
    case nft, author
}
