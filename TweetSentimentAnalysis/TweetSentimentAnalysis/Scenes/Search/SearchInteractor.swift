import Foundation

protocol SearchInteracting {
    func search(text: String?)
}

final class SearchInteractor {
    private let presenter: SearchPresenting
    private let service: SearchServicing
    private let minimumCharacters: Int
    
    init(presenter: SearchPresenting, service: SearchServicing, minimumCharacters: Int = 3) {
        self.presenter = presenter
        self.service = service
        self.minimumCharacters = minimumCharacters
    }
}

extension SearchInteractor: SearchInteracting {
    func search(text: String?) {
        guard let user = text, user.count >= minimumCharacters else {
            return
        }
        
        service.search(user: user) { [weak self] result in
            switch result {
            case .success(let tweets):
                tweets.data == nil ? self?.presenter.presentEmptySearch() : self?.presenter.presentTweets(tweets)
            case .failure:
                self?.presenter.presentGenericError()
            }
        }
    }
}
