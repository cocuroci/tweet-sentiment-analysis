import Foundation
import Moya

enum TwitterEndpoint {
    case search(user: String)
}

extension TwitterEndpoint: TargetType {
    var baseURL: URL {
        URL(string: "https://api.twitter.com/2/tweets")!
    }
    
    var path: String {
        "/search/recent"
    }
    
    var method: Moya.Method {
        .get
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        switch self {
        case .search(let user):
            return Task.requestParameters(parameters: ["query": "from:\(user)"], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        ["Authorization": "Bearer \(Environment.token)"]
    }
}
