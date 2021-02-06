import Foundation
import Moya

protocol SearchServicing {
    func search(user: String, completion: @escaping (Result<Tweets, Error>) -> Void)
}

final class SearchService {
    private let provider: MoyaProvider<TwitterEndpoint>
    private let dispatchQueue: DispatchQueue
    
    init(provider: MoyaProvider<TwitterEndpoint>, dispatchQueue: DispatchQueue = DispatchQueue.main) {
        self.provider = provider
        self.dispatchQueue = dispatchQueue
    }
}

extension SearchService: SearchServicing {
    func search(user: String, completion: @escaping (Result<Tweets, Error>) -> Void) {
        provider.request(.search(user: user)) { [weak self] result in
            self?.dispatchQueue.async {
                switch result {
                case .success(let response):
                    do {
                        let tweets = try response.filterSuccessfulStatusCodes().map(Tweets.self)
                        completion(.success(tweets))
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
