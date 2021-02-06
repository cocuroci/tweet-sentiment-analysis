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
    
    // MARK: - displayEmptyResult
    private(set) var displayEmptyResultCount = 0
    private(set) var emptyResultMessage: String?
    
    func displayEmptyResult(message: String) {
        displayEmptyResultCount += 1
        emptyResultMessage = message
    }
    
    // MARK: - displayError
    private(set) var displayErrorCount = 0
    private(set) var errorMessage: String?
    
    func displayError(message: String) {
        displayErrorCount += 1
        errorMessage = message
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
        
        XCTAssertEqual(viewControllerSpy.displayEmptyResultCount, 1)
        XCTAssertEqual(viewControllerSpy.emptyResultMessage, "Esse usuário não possui tweets recentes")
    }
    
    func testPresentGenericError_ShouldDisplayError() {
        sut.presentGenericError()
        
        XCTAssertEqual(viewControllerSpy.displayErrorCount, 1)
        XCTAssertEqual(viewControllerSpy.errorMessage, "Aconteceu um erro ao fazer a busca")
    }
}
