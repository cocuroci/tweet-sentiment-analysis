import Foundation

protocol SearchInteracting {
    func search(text: String?)
}

final class SearchInteractor {
    private let presenter: SearchPresenting
    private let searchService: SearchServicing
    private let sentimentService: SentimentServicing
    private let minimumCharacters: Int
    private var tweets = [Tweet]()
    
    init(presenter: SearchPresenting, searchService: SearchServicing, sentimentService: SentimentServicing, minimumCharacters: Int = 3) {
        self.presenter = presenter
        self.searchService = searchService
        self.sentimentService = sentimentService
        self.minimumCharacters = minimumCharacters
    }
    
    private func handleResult(tweets: Tweets?) {
        guard let arrayOfTweets = tweets?.data else {
            self.tweets = []
            presenter.presentEmptyResult()
            return
        }
        
        presenter.presentTweets(arrayOfTweets)
        self.tweets = arrayOfTweets
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
