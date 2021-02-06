import UIKit
import Moya

protocol SearchViewDisplaying: AnyObject {
    func displayTweets(_ tweets: [Tweet])
}

final class SearchViewController: UITableViewController, ViewConfiguration {
    private let interactor: SearchInteracting
    
    private var tweets = [Tweet]()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        interactor.search(text: searchBar.text)
    }
}

extension SearchViewController: SearchViewDisplaying {
    func displayTweets(_ tweets: [Tweet]) {
        self.tweets = tweets
        tableView.reloadData()
    }
}

// MARK: -  UITableViewDataSource

extension SearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tweets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = tweets[indexPath.row].text
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
