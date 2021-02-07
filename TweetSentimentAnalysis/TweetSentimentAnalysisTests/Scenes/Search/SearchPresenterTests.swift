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
}

final class SearchPresenterTests: XCTestCase {
    private let viewControllerSpy = SearchViewControllerSpy()
    private lazy var sut: SearchPresenting = {
        let presenter = SearchPresenter()
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
}
