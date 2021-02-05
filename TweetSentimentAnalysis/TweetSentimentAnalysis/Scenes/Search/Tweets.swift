import Foundation

struct Tweets: Decodable {
    let data: [Tweet]
}

struct Tweet: Decodable {
    let id: String
    let text: String
}
