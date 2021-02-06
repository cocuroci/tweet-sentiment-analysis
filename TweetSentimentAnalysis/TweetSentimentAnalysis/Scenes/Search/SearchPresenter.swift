import Foundation

protocol SearchPresenting: AnyObject {
    var viewController: SearchViewDisplaying? { get set }
    func presentTweets(_ tweets: [Tweet])
    func presentEmptyResult()
    func presentGenericError()
}

final class SearchPresenter {
    weak var viewController: SearchViewDisplaying?
}

extension SearchPresenter: SearchPresenting {
    func presentTweets(_ tweets: [Tweet]) {
        viewController?.displayTweets(tweets)
    }
    
    func presentEmptyResult() {
        viewController?.displayEmptyResult(message: "Esse usuário não possui tweets recentes")
    }
    
    func presentGenericError() {
        viewController?.displayError(message: "Aconteceu um erro ao fazer a busca")
    }
}
