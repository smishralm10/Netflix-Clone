//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 30/07/22.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    public let viewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    @Published private var titles = [Title]()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.placeholder = "Search a Movie or TV Show"
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        table.separatorStyle = .none
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchResultsUpdater = self
        view.addSubview(tableView)
        
        navigationItem.searchController = searchController
        searchController.becomeFirstResponder()
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchData() {
        viewModel.getDiscoverables()
        viewModel.$titles
            .sink { [weak self] titles in
                self?.titles = titles
                self?.tableView.reloadData()
            }.store(in: &cancellables)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Top Searches"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        var content = header.defaultContentConfiguration()
        content.text = "Top Searches"
        content.textProperties.font = .systemFont(ofSize: 20, weight: .bold)
        content.textProperties.color = .white
        header.contentConfiguration = content
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(title: titles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count > 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        
        viewModel.search(query: query, type: .movie)
        viewModel.$searchResultsTitles
            .sink { titles in
                resultsController.populateSearchResults(titles: titles)
            }
            .store(in: &cancellables)
    }
}
