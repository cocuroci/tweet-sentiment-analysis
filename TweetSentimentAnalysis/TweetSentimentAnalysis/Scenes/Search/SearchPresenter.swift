import Foundation

protocol SearchPresenting: AnyObject {
    var viewController: SearchViewDisplaying? { get set }
    func presentTweets(_ tweets: Tweets)
    func presentGenericError()
}

final class SearchPresenter {
    weak var viewController: SearchViewDisplaying?
    
    private func presentEmptySearch() {
        
    }
}

extension SearchPresenter: SearchPresenting {
    func presentTweets(_ tweets: Tweets) {
        guard let tweets = tweets.data else {
            presentEmptySearch()
            return
        }
        
        viewController?.displayTweets(tweets)
    }
    
    func presentGenericError() {
        
    }
}
