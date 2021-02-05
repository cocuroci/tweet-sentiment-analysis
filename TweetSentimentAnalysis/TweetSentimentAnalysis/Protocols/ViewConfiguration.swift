import UIKit

protocol ViewConfiguration: AnyObject {
    func configureViews()
    func buildLayout()
}

extension ViewConfiguration {
    func buildLayout() {
        configureViews()
    }
}
