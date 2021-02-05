import Foundation

protocol SearchInteracting {
    func search(text: String?)
}

final class SearchInteractor {
    private let presenter: SearchPresenting
    private let service: SearchServicing
    private let minimumCharacters = 3
    
    init(presenter: SearchPresenting, service: SearchServicing) {
        self.presenter = presenter
        self.service = service
    }
}

extension SearchInteractor: SearchInteracting {
    func search(text: String?) {
        guard let user = text, user.count >= minimumCharacters else {
            return
        }
        
        service.search(user: user) { result in
            debugPrint(result)
        }
    }
}
