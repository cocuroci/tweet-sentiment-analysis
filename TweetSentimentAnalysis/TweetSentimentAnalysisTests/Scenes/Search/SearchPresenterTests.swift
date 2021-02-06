import XCTest
@testable import TweetSentimentAnalysis

private final class SearchViewControllerSpy: SearchViewDisplaying {
    // MARK: - displayTweets
    private(set) var displayTweetsCount = 0
    private(set) var tweets: Tweets?
    
    func displayTweets(_ tweets: [Tweet]) {
        
    }
    
    // MARK: - displayEmptyResult
    private(set) var displayEmptyResultCount = 0
    private(set) var emptyResultMessage: String?
    
    func displayEmptyResult(message: String) {
        
    }
    
    // MARK: - displayError
    private(set) var displayErrorCount = 0
    private(set) var errorMessage: String?
    
    func displayError(message: String) {
        
    }
}

final class SearchPresenterTests: XCTestCase {
    private let viewControllerSpy = SearchViewControllerSpy()
    private lazy var sut: SearchPresenting = {
        let presenter = SearchPresenter()
        presenter.viewController = viewControllerSpy
        return presenter
    }()
}
