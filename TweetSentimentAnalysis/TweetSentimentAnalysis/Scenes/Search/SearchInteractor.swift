import Foundation

protocol SearchInteracting {
    func search(text: String?)
}

final class SearchInteractor {
    private let service: SearchServicing
    private let minimumCharacters = 3
    
    init(service: SearchServicing) {
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
