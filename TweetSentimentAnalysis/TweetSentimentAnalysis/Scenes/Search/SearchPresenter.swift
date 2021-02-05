import Foundation

protocol SearchPresenting {
    var viewController: SearchViewDisplaying? { get set }
    func presentTweets(_ tweets: Tweets)
}

final class SearchPresenter {
    weak var viewController: SearchViewDisplaying?
}

extension SearchPresenter: SearchPresenting {
    func presentTweets(_ tweets: Tweets) {
        
    }
}
