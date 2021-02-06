import Foundation

protocol SearchInteracting {
    func search(text: String?)
    func didSelectTweet(with indexPath: IndexPath)
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
    
    private func analysisTweet(_ tweet: Tweet) {
        sentimentService.analysis(content: tweet.text) { result in
            switch result {
            case .success(let sentiment):
                debugPrint(sentiment)
            case .failure(let error):
                debugPrint(error)
            }
        }
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
    
    func didSelectTweet(with indexPath: IndexPath) {
        guard tweets.indices.contains(indexPath.row) else {
            return
        }
        
        analysisTweet(tweets[indexPath.row])
    }
}
