import Foundation

struct CryptoResponse: Decodable {
    let code: String
    let data: [Crypto]
}

struct Crypto: Decodable, Identifiable {
    let id: Int
    let name: String
    let usdPrice: Decimal?
    let eurPrice: Decimal?
    let tags: [Tag]
    
    init(
        id: Int,
        name: String,
        usdPrice: Decimal? = nil,
        eurPrice: Decimal? = nil,
        tags: [Tag]
    ) {
        self.id = id
        self.name = name
        self.usdPrice = usdPrice
        self.eurPrice = eurPrice
        self.tags = tags
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, tags
        case usdPrice = "usd"
        case eurPrice = "eur"
        case price
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        tags = try container.decode([Tag].self, forKey: .tags)
        
        // Handling different API response formats
        if let usd = try? container.decode(Decimal.self, forKey: .usdPrice) {
            usdPrice = usd
            eurPrice = nil
        } else if let priceContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .price) {
            usdPrice = try priceContainer.decode(Decimal.self, forKey: .usdPrice)
            eurPrice = try priceContainer.decodeIfPresent(Decimal.self, forKey: .eurPrice)
        } else {
            usdPrice = nil
            eurPrice = nil
        }
    }
}

enum Tag: String, Decodable {
    case deposit = "deposit"
    case withdrawal = "withdrawal"
}
