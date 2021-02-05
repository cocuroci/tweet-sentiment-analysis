import Foundation

protocol SearchInteracting {
    func search(text: String?)
}

final class SearchInteractor {
    private let presenter: SearchPresenting
    private let service: SearchServicing
    private let minimumCharacters = 3
    
    init(presenter: SearchPresenting, service: SearchServicing) {
        self.presenter = presenter
        self.service = service
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
                self?.presenter.presentTweets(tweets)
            case .failure(let error):
                break
            }
        }
    }
}
