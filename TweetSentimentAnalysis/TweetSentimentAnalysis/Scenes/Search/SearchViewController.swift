import UIKit
import Moya

protocol SearchViewDisplaying: AnyObject {
    
}

final class SearchViewController: UITableViewController, ViewConfiguration {
    private let interactor: SearchInteracting
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar tweets do usuário"
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    init(interactor: SearchInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViews() {
        title = "Buscar tweets"
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        tableView.tableFooterView = UIView()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        interactor.search(text: searchBar.text)
    }
}
