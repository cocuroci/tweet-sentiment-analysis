import Foundation

protocol SearchPresenting {
    var viewController: SearchViewDisplaying? { get set }
    func presentTweets(_ tweets: Tweets)
    func presentEmptySearch()
    func presentGenericError()
}

final class SearchPresenter {
    weak var viewController: SearchViewDisplaying?
}

extension SearchPresenter: SearchPresenting {
    func presentTweets(_ tweets: Tweets) {
        
    }
    
    func presentEmptySearch() {
        
    }
    
    func presentGenericError() {
        
    }
}
