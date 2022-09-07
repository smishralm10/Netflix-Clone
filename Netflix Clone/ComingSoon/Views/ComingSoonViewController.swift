//
//  ComingSoonViewController.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 04/09/22.
//

import UIKit
import Combine

class ComingSoonViewController: UIViewController {
    
    let viewModel = ComingSoonViewModel()
    private var cancellables = Set<AnyCancellable>()
    @Published var upComingTitles = [Title]()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.register(ComingSoonTableViewCell.self, forCellReuseIdentifier: ComingSoonTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Coming Soon"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchData() {
        viewModel.getUpComingMovies()
        viewModel.$upComingMovies
            .sink { [weak self] titles in
                self?.upComingTitles = titles
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension ComingSoonViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        upComingTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ComingSoonTableViewCell.identifier, for: indexPath) as? ComingSoonTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(with: upComingTitles[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        500
    }
    
}


