import Foundation

protocol SearchInteracting {
    func search(text: String?)
}

final class SearchInteractor {
    private let presenter: SearchPresenting
    private let searchService: SearchServicing
    private let minimumCharacters: Int
    
    init(presenter: SearchPresenting, searchService: SearchServicing, minimumCharacters: Int = 3) {
        self.presenter = presenter
        self.searchService = searchService
        self.minimumCharacters = minimumCharacters
    }
    
    private func handleResult(tweets: Tweets?) {
        guard let arrayOfTweets = tweets?.data else {
            presenter.presentEmptyResult()
            return
        }
        
        presenter.presentTweets(arrayOfTweets)
    }
}

extension SearchInteractor: SearchInteracting {
    func search(text: String?) {
        guard let username = text, username.count >= minimumCharacters else {
            return
        }
        
        searchService.search(user: username) { [weak self] result in
            switch result {
            case .success(let tweets):
                self?.handleResult(tweets: tweets)
            case .failure:
                self?.presenter.presentGenericError()
            }
        }
    }
}
