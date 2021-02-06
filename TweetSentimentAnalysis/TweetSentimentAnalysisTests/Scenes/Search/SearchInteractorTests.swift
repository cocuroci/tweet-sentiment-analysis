import XCTest
import Moya
@testable import TweetSentimentAnalysis

private final class SearchPresenterSpy: SearchPresenting {
    var viewController: SearchViewDisplaying?
    
    // MARK: - presentTweets
    private(set) var presentTweetsCallsCount = 0
    private(set) var presentTweets: [Tweet]?
    
    func presentTweets(_ tweets: [Tweet]) {
        presentTweetsCallsCount += 1
        presentTweets = tweets
    }
    
    // MARK: - presentEmptyResult
    private(set) var presentEmptyResultCount = 0
    
    func presentEmptyResult() {
        presentEmptyResultCount += 1
    }
    
    // MARK: - presentGenericError
    private(set) var presentGenericErrorCount = 0
    
    func presentGenericError() {
        presentGenericErrorCount += 1
    }
}

private final class SearchServiceMock: SearchServicing {
    var result: Result<Tweets, Error>?
    
    func search(user: String, completion: @escaping (Result<Tweets, Error>) -> Void) {
        guard let result = result else {
            XCTFail("Mocked retult for search method is nil")
            return
        }
        
        completion(result)
    }
}

final class SearchInteractorTests: XCTestCase {
    private let presenterSpy = SearchPresenterSpy()
    private let serviceMock = SearchServiceMock()
    
    private lazy var sut: SearchInteracting = {
        let interactor = SearchInteractor(presenter: presenterSpy, service: serviceMock)
        return interactor
    }()
    
    func testSearch_WhenTextCharacterIsLessThanMinimumCharacters_ShouldDoNothing() {
        let tweets = Tweets(data: [Tweet(id: "1234", text: "Tweet")])
        serviceMock.result = .success(tweets)
        
        sut.search(text: "us")
        
        XCTAssertEqual(presenterSpy.presentTweetsCallsCount, 0)
        XCTAssertNil(presenterSpy.presentTweets)
    }
    
    func testSearch_WhenTextCharacterIsGreaterThanOrEqualToMinimumCharactersAndSuccessResponse_ShouldPresentTweets() {
        let tweets = Tweets(data: [Tweet(id: "1234", text: "Tweet")])
        serviceMock.result = .success(tweets)
        
        sut.search(text: "user")
        
        XCTAssertEqual(presenterSpy.presentTweetsCallsCount, 1)
        XCTAssertEqual(presenterSpy.presentTweets?.count, tweets.data?.count)
        XCTAssertEqual(presenterSpy.presentTweets?.first?.id, tweets.data?.first?.id)
        XCTAssertEqual(presenterSpy.presentTweets?.first?.text, tweets.data?.first?.text)
    }
    
    func testSearch_WhenTextCharacterIsGreaterThanOrEqualToMinimumCharactersAndSuccessResponseAndResultIsEmpty_ShouldPresentEmptySearch() {
        let tweets = Tweets(data: nil)
        serviceMock.result = .success(tweets)
        
        sut.search(text: "user")
        
        XCTAssertEqual(presenterSpy.presentEmptyResultCount, 1)
        XCTAssertNil(presenterSpy.presentTweets)
    }
    
    func testSearch_WhenTextCharacterIsGreaterThanOrEqualToMinimumCharactersAndFailureResponse_ShouldPresentGenericError() {
        serviceMock.result = .failure(MoyaError.statusCode(Response(statusCode: 400, data: Data())))
        
        sut.search(text: "user")
        
        XCTAssertEqual(presenterSpy.presentGenericErrorCount, 1)
    }
}
