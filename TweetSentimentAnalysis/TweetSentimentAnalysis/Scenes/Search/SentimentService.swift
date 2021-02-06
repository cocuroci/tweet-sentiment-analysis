import Foundation
import Moya

protocol SentimentServicing {
    func analysis(content: String, completion: @escaping (Result<Sentiment, Error>) -> Void)
}

final class SentimentService {
    private let provider: MoyaProvider<GoogleEndpoint>
    private let dispatchQueue: DispatchQueue
    
    init(provider: MoyaProvider<GoogleEndpoint>, dispatchQueue: DispatchQueue = DispatchQueue.main) {
        self.provider = provider
        self.dispatchQueue = dispatchQueue
    }
}

extension SentimentService: SentimentServicing {
    func analysis(content: String, completion: @escaping (Result<Sentiment, Error>) -> Void) {
        provider.request(.analyzeSentiment(content: content)) { [weak self] result in
            self?.dispatchQueue.async {
                switch result {
                case .success(let response):
                    do {
                        let documentSentiment = try response.filterSuccessfulStatusCodes().map(DocumentSentiment.self)
                        completion(.success(documentSentiment.sentiment))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
