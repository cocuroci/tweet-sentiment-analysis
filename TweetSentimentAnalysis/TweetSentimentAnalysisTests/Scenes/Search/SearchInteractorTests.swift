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
    
    // MARK: - presentSearchError
    private(set) var presentSearchErrorCount = 0
    
    func presentSearchError() {
        presentSearchErrorCount += 1
    }
    
    // MARK: - presentPositiveSentiment
    private(set) var presentPositiveSentimentCount = 0
    
    func presentPositiveSentiment(tweet: Tweet) {
        presentPositiveSentimentCount += 1
    }
    
    // MARK: - presentNegativeSentiment
    private(set) var presentNegativeSentimentCount = 0
    
    func presentNegativeSentiment(tweet: Tweet) {
        presentNegativeSentimentCount += 1
    }
    
    // MARK: - presentNeutralSentiment
    private(set) var presentNeutralSentimentCount = 0
    
    func presentNeutralSentiment(tweet: Tweet) {
        presentNeutralSentimentCount += 1
    }
    
    // MARK: - presentAnalysisError
    private(set) var presentAnalysisErrorCount = 0
    
    func presentAnalysisError() {
        presentAnalysisErrorCount += 1
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

private final class SentimentServiceMock: SentimentServicing {
    var result: Result<Sentiment, Error>?
    
    func analysis(content: String, completion: @escaping (Result<Sentiment, Error>) -> Void) {
        guard let result = result else {
            XCTFail("Mocked retult for analysis method is nil")
            return
        }
        
        completion(result)
    }
}

final class SearchInteractorTests: XCTestCase {
    private let presenterSpy = SearchPresenterSpy()
    private let searchServiceMock = SearchServiceMock()
    private let sentimentServiceMock = SentimentServiceMock()
    
    private lazy var sut: SearchInteracting = {
        let interactor = SearchInteractor(
            presenter: presenterSpy,
            searchService: searchServiceMock,
            sentimentService: sentimentServiceMock
        )
        return interactor
    }()
    
    func testSearch_WhenTextCharacterIsLessThanMinimumCharacters_ShouldDoNothing() {
        let tweets = Tweets(data: [Tweet(id: "1234", text: "Tweet")])
        searchServiceMock.result = .success(tweets)
        
        sut.search(text: "us")
        
        XCTAssertEqual(presenterSpy.presentTweetsCallsCount, 0)
        XCTAssertNil(presenterSpy.presentTweets)
    }
    
    func testSearch_WhenTextCharacterIsGreaterThanOrEqualToMinimumCharactersAndSuccessResponse_ShouldPresentTweets() {
        let tweets = Tweets(data: [Tweet(id: "1234", text: "Tweet")])
        searchServiceMock.result = .success(tweets)
        
        sut.search(text: "user")
        
        XCTAssertEqual(presenterSpy.presentTweetsCallsCount, 1)
        XCTAssertEqual(presenterSpy.presentTweets?.count, tweets.data?.count)
        XCTAssertEqual(presenterSpy.presentTweets?.first?.id, tweets.data?.first?.id)
        XCTAssertEqual(presenterSpy.presentTweets?.first?.text, tweets.data?.first?.text)
    }
    
    func testSearch_WhenTextCharacterIsGreaterThanOrEqualToMinimumCharactersAndSuccessResponseAndResultIsEmpty_ShouldPresentEmptySearch() {
        let tweets = Tweets(data: nil)
        searchServiceMock.result = .success(tweets)
        
        sut.search(text: "user")
        
        XCTAssertEqual(presenterSpy.presentEmptyResultCount, 1)
        XCTAssertNil(presenterSpy.presentTweets)
    }
    
    func testSearch_WhenTextCharacterIsGreaterThanOrEqualToMinimumCharactersAndFailureResponse_ShouldPresentGenericError() {
        searchServiceMock.result = .failure(MoyaError.statusCode(Response(statusCode: 400, data: Data())))
        
        sut.search(text: "user")
        
        XCTAssertEqual(presenterSpy.presentSearchErrorCount, 1)
    }
    
    func testDidSelectTweet_WhenResultIsSuccessAndScoreIsPositive_ShouldPresentPositiveSentiment() {
        let tweets = Tweets(data: [Tweet(id: "1234", text: "Tweet")])
        searchServiceMock.result = .success(tweets)
        sut.search(text: "user")
        
        sentimentServiceMock.result = .success(Sentiment(magnitude: 0, score: 0.25))
        
        sut.didSelectTweet(with: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(presenterSpy.presentPositiveSentimentCount, 1)
    }
    
    func testDidSelectTweet_WhenResultIsSuccessAndScoreIsPositive_ShouldPresentNeutralSentiment() {
        let tweets = Tweets(data: [Tweet(id: "1234", text: "Tweet")])
        searchServiceMock.result = .success(tweets)
        sut.search(text: "user")
        
        sentimentServiceMock.result = .success(Sentiment(magnitude: 0, score: 0.0))
        
        sut.didSelectTweet(with: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(presenterSpy.presentNeutralSentimentCount, 1)
    }
    
    func testDidSelectTweet_WhenResultIsSuccessAndScoreIsPositive_ShouldPresentNegativeSentiment() {
        let tweets = Tweets(data: [Tweet(id: "1234", text: "Tweet")])
        searchServiceMock.result = .success(tweets)
        sut.search(text: "user")
        
        sentimentServiceMock.result = .success(Sentiment(magnitude: 0, score: -0.25))
        
        sut.didSelectTweet(with: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(presenterSpy.presentNegativeSentimentCount, 1)
    }
    
    func testDidSelectTweet_WhenResultIsFailure_ShouldPresentAnalysisErrorCount() {
        let tweets = Tweets(data: [Tweet(id: "1234", text: "Tweet")])
        searchServiceMock.result = .success(tweets)
        sut.search(text: "user")
        
        sentimentServiceMock.result = .failure(MoyaError.statusCode(Response(statusCode: 400, data: Data())))
        
        sut.didSelectTweet(with: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(presenterSpy.presentAnalysisErrorCount, 1)
    }
}
