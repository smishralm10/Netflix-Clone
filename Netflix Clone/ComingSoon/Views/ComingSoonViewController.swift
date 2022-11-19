//
//  ComingSoonViewController.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 04/09/22.
//

import UIKit
import Combine

class ComingSoonViewController: UIViewController {
    
    private var cancellables = [AnyCancellable]()
    private let viewModel: ComingSoonViewModelType
    private let appear = PassthroughSubject<Void, Never>()
    private let selection = PassthroughSubject<Int, Never>()
    private var upComingTitles = [Title]()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.register(ComingSoonTableViewCell.self, forCellReuseIdentifier: ComingSoonTableViewCell.identifier)
        return table
    }()
    
    init(viewModel: ComingSoonViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind(to: viewModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appear.send(())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func configureUI() {
        title = "Coming Soon"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func bind(to viewModel: ComingSoonViewModelType) {
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
        
        let input = ComingSoonViewModelInput(appear: appear.eraseToAnyPublisher(), selection: selection.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)
        
        output.sink { [unowned self] state in
            self.render(state)
        }
        .store(in: &cancellables)
    }
    
    func render(_ state: ComingSoonTitleState) {
        switch state {
        case .loading:
            print("Loading")
        case .success(let titles):
            self.upComingTitles = titles
            tableView.reloadData()
        case .failure(let error):
            print(error)
        }
    }
}

extension ComingSoonViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        upComingTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ComingSoonTableViewCell.identifier, for: indexPath) as? ComingSoonTableViewCell else {
            return UITableViewCell()
        }
        cell.bind(with: upComingTitles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        500
    }
    
}

extension ComingSoonViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = upComingTitles[indexPath.row]
        selection.send(title.id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

