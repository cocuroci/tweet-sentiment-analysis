import UIKit
import Moya

enum SearchFactory {
    static func make() -> UIViewController {
        let searchService: SearchServicing = SearchService(provider: MoyaProvider<TwitterEndpoint>())
        let sentimentService: SentimentServicing = SentimentService(provider: MoyaProvider<GoogleEndpoint>())
        let presenter: SearchPresenting = SearchPresenter()
        let interactor: SearchInteracting = SearchInteractor(
            presenter: presenter,
            searchService: searchService,
            sentimentService: sentimentService
        )
        let viewController = SearchViewController(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
