import Foundation

protocol SearchPresenting: AnyObject {
    var viewController: SearchViewDisplaying? { get set }
    func presentTweets(_ tweets: [Tweet])
    func presentEmptyResult()
    func presentSearchError()
    func presentAnalysisError()
    func presentPositiveSentiment(tweet: Tweet)
    func presentNegativeSentiment(tweet: Tweet)
    func presentNeutralSentiment(tweet: Tweet)
}

final class SearchPresenter {
    weak var viewController: SearchViewDisplaying?
    private let stringMaxLength: Int
    
    init(stringMaxLength: Int = 120) {
        self.stringMaxLength = stringMaxLength
    }
}

extension SearchPresenter: SearchPresenting {
    func presentTweets(_ tweets: [Tweet]) {
        viewController?.displayTweets(tweets)
    }
    
    func presentEmptyResult() {
        viewController?.clearData()
        viewController?.displayError(title: "Ops!", message: "Esse usuário não possui tweets recentes", buttonText: "Ok")
    }
    
    func presentSearchError() {
        viewController?.displayError(title: "Ops!", message: "Aconteceu um erro ao fazer a busca", buttonText: "Ok")
    }
    
    func presentAnalysisError() {
        viewController?.displayError(title: "Ops!", message: "Aconteceu um erro ao analisar o tweet", buttonText: "Ok")
    }
    
    func presentPositiveSentiment(tweet: Tweet) {
        viewController?.displaySentimentAlert(
            title: "Sentimento do texto: 😀",
            message: tweet.text.maxLength(stringMaxLength),
            buttonText: "Ok"
        )
    }
    
    func presentNegativeSentiment(tweet: Tweet) {
        viewController?.displaySentimentAlert(
            title: "Sentimento do texto: 😩",
            message: tweet.text.maxLength(stringMaxLength),
            buttonText: "Ok"
        )
    }
    
    func presentNeutralSentiment(tweet: Tweet) {
        viewController?.displaySentimentAlert(
            title: "Sentimento do texto: 😐",
            message: tweet.text.maxLength(stringMaxLength),
            buttonText: "Ok"
        )
    }
}
