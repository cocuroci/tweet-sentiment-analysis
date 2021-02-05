import UIKit
import Moya

final class SearchViewController: UITableViewController, ViewConfiguration {
    private let interactor: SearchInteracting
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar tweets do usuário"
        searchController.searchBar.autocapitalizationType = .none
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
        searchController.searchBar.delegate = self
        tableView.tableFooterView = UIView()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        interactor.search(text: searchBar.text)
    }
}
