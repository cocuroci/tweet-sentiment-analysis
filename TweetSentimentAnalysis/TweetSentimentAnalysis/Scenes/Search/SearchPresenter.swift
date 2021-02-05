import Foundation
import UIKit

protocol SearchPresenting {
    var viewController: UIViewController? { get set }
}

final class SearchPresenter {
    weak var viewController: UIViewController?
}

extension SearchPresenter: SearchPresenting {
    
}
