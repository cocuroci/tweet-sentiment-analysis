import XCTest
@testable import TweetSentimentAnalysis

private final class SearchViewControllerSpy: SearchViewDisplaying {
    // MARK: - displayTweets
    private(set) var displayTweetsCount = 0
    private(set) var tweets: [Tweet]?
    
    func displayTweets(_ tweets: [Tweet]) {
        displayTweetsCount += 1
        self.tweets = tweets
    }
    
    // MARK: - displayError
    private(set) var displayErrorCount = 0
    private(set) var titleError: String?
    private(set) var messageError: String?
    private(set) var buttonTextError: String?
    
    func displayError(title: String, message: String, buttonText: String) {
        displayErrorCount += 1
        titleError = title
        messageError = message
        buttonTextError = buttonText
    }
    
    // MARK: - displaySentimentAlert
    private(set) var displaySentimentAlertCount = 0
    private(set) var titleSentiment: String?
    private(set) var messageSentiment: String?
    private(set) var buttonTextSentiment: String?
    
    func displaySentimentAlert(title: String, message: String, buttonText: String) {
        displaySentimentAlertCount += 1
        titleSentiment = title
        messageSentiment = message
        buttonTextSentiment = buttonText
    }
    
    // MARK: - clearData
    private(set) var clearDataCount = 0
    
    func clearData() {
        clearDataCount += 1
    }
    
    // MARK: - displayLoader
    private(set) var displayLoaderCount = 0
    
    func displayLoader() {
        displayLoaderCount += 1
    }
    
    // MARK: - hideLoader
    private(set) var hideLoaderCount = 0
    
    func hideLoader() {
        hideLoaderCount += 1
    }
}

final class SearchPresenterTests: XCTestCase {
    private let viewControllerSpy = SearchViewControllerSpy()
    private lazy var sut: SearchPresenting = {
        let presenter = SearchPresenter(stringMaxLength: 50)
        presenter.viewController = viewControllerSpy
        return presenter
    }()
    
    func testPresentTweets_WhenTweetsDataIsNotEmpty_ShouldDisplayTweets() {
        let tweets = [Tweet(id: "1234", text: "Tweet")]
        
        sut.presentTweets(tweets)
        
        XCTAssertEqual(viewControllerSpy.displayTweetsCount, 1)
        XCTAssertEqual(viewControllerSpy.tweets?.count, tweets.count)
        XCTAssertEqual(viewControllerSpy.tweets?.first?.id, tweets.first?.id)
        XCTAssertEqual(viewControllerSpy.tweets?.first?.text, tweets.first?.text)
    }
    
    func testPresentEmptyResult_ShouldDisplayEmptyResult() {
        sut.presentEmptyResult()
        
        XCTAssertEqual(viewControllerSpy.displayErrorCount, 1)
        XCTAssertEqual(viewControllerSpy.titleError, "Ops!")
        XCTAssertEqual(viewControllerSpy.messageError, "Esse usuário não possui tweets recentes")
        XCTAssertEqual(viewControllerSpy.buttonTextError, "Ok")
        XCTAssertEqual(viewControllerSpy.clearDataCount, 1)
    }
    
    func testPresentSearchError_ShouldDisplayError() {
        sut.presentSearchError()
        
        XCTAssertEqual(viewControllerSpy.displayErrorCount, 1)
        XCTAssertEqual(viewControllerSpy.titleError, "Ops!")
        XCTAssertEqual(viewControllerSpy.messageError, "Aconteceu um erro ao fazer a busca")
        XCTAssertEqual(viewControllerSpy.buttonTextError, "Ok")
    }
    
    func testPresentAnalysisError_ShouldDisplayError() {
        sut.presentAnalysisError()
        
        XCTAssertEqual(viewControllerSpy.displayErrorCount, 1)
        XCTAssertEqual(viewControllerSpy.titleError, "Ops!")
        XCTAssertEqual(viewControllerSpy.messageError, "Aconteceu um erro ao analisar o tweet")
        XCTAssertEqual(viewControllerSpy.buttonTextError, "Ok")
    }
    
    func testPresentPositiveSentiment_ShouldDisplaySentimentAlert() {
        let tweet = Tweet(id: "1234", text: "Olá, esse é um tweet positivo.")
        
        sut.presentPositiveSentiment(tweet: tweet)
        
        XCTAssertEqual(viewControllerSpy.displaySentimentAlertCount, 1)
        XCTAssertEqual(viewControllerSpy.titleSentiment, "Sentimento do texto: 😀")
        XCTAssertEqual(viewControllerSpy.messageSentiment, "Olá, esse é um tweet positivo.")
        XCTAssertEqual(viewControllerSpy.buttonTextSentiment, "Ok")
    }
    
    func testPresentPositiveSentiment_WhenTweetLengthIsGreaterThanTheLimit_ShouldDisplaySentimentAlert() {
        let tweet = Tweet(id: "1234", text: "Olá, esse é um tweet positivo onde o texto passou do limite configurado no presenter")
        
        sut.presentPositiveSentiment(tweet: tweet)
        
        XCTAssertEqual(viewControllerSpy.displaySentimentAlertCount, 1)
        XCTAssertEqual(viewControllerSpy.titleSentiment, "Sentimento do texto: 😀")
        XCTAssertEqual(viewControllerSpy.messageSentiment, "Olá, esse é um tweet positivo onde o texto passou ...")
        XCTAssertEqual(viewControllerSpy.buttonTextSentiment, "Ok")
    }
    
    func testPresentNeutralSentiment_ShouldDisplaySentimentAlert() {
        let tweet = Tweet(id: "1234", text: "Olá, esse é um tweet neutro.")
        
        sut.presentNeutralSentiment(tweet: tweet)
        
        XCTAssertEqual(viewControllerSpy.displaySentimentAlertCount, 1)
        XCTAssertEqual(viewControllerSpy.titleSentiment, "Sentimento do texto: 😐")
        XCTAssertEqual(viewControllerSpy.messageSentiment, "Olá, esse é um tweet neutro.")
        XCTAssertEqual(viewControllerSpy.buttonTextSentiment, "Ok")
    }
    
    func testPresentNegativeSentiment_ShouldDisplaySentimentAlert() {
        let tweet = Tweet(id: "1234", text: "Olá, esse é um tweet negativo.")
        
        sut.presentNegativeSentiment(tweet: tweet)
        
        XCTAssertEqual(viewControllerSpy.displaySentimentAlertCount, 1)
        XCTAssertEqual(viewControllerSpy.titleSentiment, "Sentimento do texto: 😩")
        XCTAssertEqual(viewControllerSpy.messageSentiment, "Olá, esse é um tweet negativo.")
        XCTAssertEqual(viewControllerSpy.buttonTextSentiment, "Ok")
    }
    
    func testPresentLoader_ShouldDisplayLoader() {
        sut.presentLoader()
        
        XCTAssertEqual(viewControllerSpy.displayLoaderCount, 1)
    }
    
    func testHideLoader_ShouldDisplayLoader() {
        sut.hideLoader()
        
        XCTAssertEqual(viewControllerSpy.hideLoaderCount, 1)
    }
}
