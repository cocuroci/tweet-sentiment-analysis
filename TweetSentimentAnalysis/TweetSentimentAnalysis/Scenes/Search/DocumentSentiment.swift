import Foundation

struct DocumentSentiment: Decodable {
    let sentiment: Sentiment
    
    enum CodingKeys: String, CodingKey {
        case sentiment = "documentSentiment"
    }
}

struct Sentiment: Decodable {
    let magnitude: Float
    let score: Float
}
