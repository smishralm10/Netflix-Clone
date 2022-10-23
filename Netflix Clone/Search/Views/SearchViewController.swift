//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 30/07/22.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    private var cancellables = [AnyCancellable]()
    private let viewModel: TitleSearchViewModelType
    private let selection = PassthroughSubject<Int, Never>()
    private let search = PassthroughSubject<String, Never>()
    private let appear = PassthroughSubject<Void, Never>()
    private var topTitles = [Title]()
    
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
    
    init(viewModel: TitleSearchViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind(to: viewModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appear.send()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureUI() {
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchResultsUpdater = self
        view.addSubview(tableView)
        
        navigationItem.searchController = searchController
        searchController.becomeFirstResponder()
    }
    
    private func bind(to viewModel: TitleSearchViewModelType) {
        cancellables.forEach({ $0.cancel() })
        cancellables.removeAll()
        
        let input = TitleSearchViewModelInput(appear: appear.eraseToAnyPublisher(), search: search.eraseToAnyPublisher(), selection: selection.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)
        
        output.sink { [unowned self] state in
            self.render(state)
        }
        .store(in: &cancellables)
    }
    
    private func render(_ state: TitleSearchState) {
        switch state {
        case .idle(let titles):
            self.topTitles = titles
            tableView.reloadData()
        case .noResults:
            guard let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
                return
            }
            resultsController.bind(with: [])
        case .loading:
            print("loading")
        case .success(let titles):
            guard let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
                return
            }
            resultsController.bind(with: titles)
        case.failure(let error):
            print(error)
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topTitles.count
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
        cell.bind(to: self.topTitles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let text = searchBar.text else {
            return
        }
        search.send(text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
        search.send("")
    }
}
