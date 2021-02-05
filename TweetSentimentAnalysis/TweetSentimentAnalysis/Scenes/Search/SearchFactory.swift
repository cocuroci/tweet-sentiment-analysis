import UIKit
import Moya

enum SearchFactory {
    static func make() -> UIViewController {
        let service: SearchServicing = SearchService(provider: MoyaProvider<SearchEndpoint>())
        let interactor: SearchInteracting = SearchInteractor(service: service)
        return SearchViewController(interactor: interactor)
    }
}
