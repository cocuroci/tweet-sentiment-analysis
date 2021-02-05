import Foundation
import Moya

enum SearchEndpoint {
    case search(user: String)
}

extension SearchEndpoint: TargetType {
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
    
    var headers: [String : String]? {
        ["Authorization": "Bearer \(Environment.token)"]
    }
}
