import UIKit
import Moya

enum SearchFactory {
    static func make() -> UIViewController {
        let service: SearchServicing = SearchService(provider: MoyaProvider<SearchEndpoint>())
        let presenter: SearchPresenting = SearchPresenter()
        let interactor: SearchInteracting = SearchInteractor(presenter: presenter, service: service)
        return SearchViewController(interactor: interactor)
    }
}
