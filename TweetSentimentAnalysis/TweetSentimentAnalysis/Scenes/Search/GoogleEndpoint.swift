import Foundation
import Moya

enum GoogleEndpoint {
    case analyzeSentiment(content: String)
}

extension GoogleEndpoint: TargetType {
    var baseURL: URL {
        URL(string: "https://language.googleapis.com/v1beta2")!
    }
    
    var path: String {
        "/documents:analyzeSentiment"
    }
    
    var method: Moya.Method {
        .post
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        switch self {
        case .analyzeSentiment(let content):
            return Task.requestCompositeParameters(
                bodyParameters: ["document": ["content": content, "type": "PLAIN_TEXT"]],
                bodyEncoding: JSONEncoding.default,
                urlParameters: ["key": Environment.token]
            )
        }
    }
    
    var headers: [String : String]? {
        [:]
    }
}
