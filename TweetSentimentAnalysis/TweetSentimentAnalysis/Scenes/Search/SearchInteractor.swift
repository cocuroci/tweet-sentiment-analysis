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
    
    private func handleSearchResult(tweets: Tweets?) {
        guard let arrayOfTweets = tweets?.data else {
            self.tweets = []
            presenter.presentEmptyResult()
            return
        }
        
        presenter.presentTweets(arrayOfTweets)
        self.tweets = arrayOfTweets
    }
    
    private func handleAnalysisResult(tweet: Tweet, sentiment: Sentiment) {
        switch sentiment.score {
        case 0.25...:
            presenter.presentPositiveSentiment(tweet: tweet)
        case ...(-0.25):
            presenter.presentNegativeSentiment(tweet: tweet)
        default:
            presenter.presentNeutralSentiment(tweet: tweet)
        }
    }
    
    private func analysisTweet(_ tweet: Tweet) {
        sentimentService.analysis(content: tweet.text) { [weak self] result in
            switch result {
            case .success(let sentiment):
                self?.handleAnalysisResult(tweet: tweet, sentiment: sentiment)
            case .failure:
                self?.presenter.presentAnalysisError()
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
                self?.handleSearchResult(tweets: tweets)
            case .failure:
                self?.presenter.presentSearchError()
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
