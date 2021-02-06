import UIKit
import Moya

enum SearchFactory {
    static func make() -> UIViewController {
        let service: SearchServicing = SearchService(provider: MoyaProvider<TwitterEndpoint>())
        let presenter: SearchPresenting = SearchPresenter()
        let interactor: SearchInteracting = SearchInteractor(presenter: presenter, service: service)
        let viewController = SearchViewController(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
