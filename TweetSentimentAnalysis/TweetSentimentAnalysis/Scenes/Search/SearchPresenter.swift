import Foundation

protocol SearchPresenting: AnyObject {
    var viewController: SearchViewDisplaying? { get set }
    func presentTweets(_ tweets: Tweets)
    func presentGenericError()
}

final class SearchPresenter {
    weak var viewController: SearchViewDisplaying?
}

extension SearchPresenter: SearchPresenting {
    func presentTweets(_ tweets: Tweets) {
        guard let tweets = tweets.data else {
            viewController?.displayEmptyResult(message: "Esse usuário não possui tweets recentes")
            return
        }
        
        viewController?.displayTweets(tweets)
    }
    
    func presentGenericError() {
        viewController?.displayError(message: "Aconteceu um erro ao fazer a busca")
    }
}
