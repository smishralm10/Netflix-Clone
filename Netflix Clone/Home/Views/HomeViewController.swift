//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 30/07/22.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    var cancellables = Set<AnyCancellable>()
    private var watchListTitles = [Title]()
    
    private var sectionTitles = ["Trending", "Top Rated", "Popular"]
    private var sectionTitles2 = ["Trending", "Top Rated", "Popular", "My List"]

    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifer)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = true
        
        view.addSubview(homeFeedTable)
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
        
        // Do any additional setup after loading the view.
        let headerView = HeroUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450), viewModel: viewModel)
        homeFeedTable.tableHeaderView = headerView
        
        loadFeedData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func configureNavBar() {
        let image = UIImage(named: "netflixLogo")?.withRenderingMode(.alwaysOriginal).resizeTo(size: CGSize(width: 20, height: 35))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
    }
    
    private func loadFeedData() {
        viewModel.getTrendingMovies()
        viewModel.getPopularMovies()
        viewModel.getTopRatedMovies()
        viewModel.getWatchList()
        viewModel.$watchList
            .sink { [weak self] titles in
                self?.watchListTitles = titles
                self?.homeFeedTable.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if watchListTitles.count > 0 {
            return sectionTitles2.count
        }
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifer, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.trendingMovies.rawValue:
            viewModel.$trendingMovies
                .sink { titles in
                    cell.configure(with: titles)
                }
                .store(in: &cancellables)
        case Sections.popular.rawValue:
            viewModel.$popularMovies
                .sink { titles in
                    cell.configure(with: titles)
                }
                .store(in: &cancellables)
        case Sections.toprated.rawValue:
            viewModel.$topRatedMovies
                .sink { titles in
                    cell.configure(with: titles)
                }
                .store(in: &cancellables)
        case Sections.watchList.rawValue:
            viewModel.$watchList
                .sink { titles in
                    cell.configure(with: titles)
                }
                .store(in: &cancellables)
        default:
            return UITableViewCell()
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if watchListTitles.count > 0 {
            return sectionTitles2[section]
        }
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        var content = header.defaultContentConfiguration()
        content.text = watchListTitles.count > 0 ? sectionTitles2[section] : sectionTitles[section]
        content.textProperties.font = .systemFont(ofSize: 18, weight: .semibold)
        content.textProperties.color = .white
        header.contentConfiguration = content
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defualtOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defualtOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
}

extension UIImage {
    func resizeTo(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: size))
        }
        
        return image.withRenderingMode(self.renderingMode)
    }
}

enum Sections: Int {
    case trendingMovies = 0
    case toprated = 1
    case popular = 2
    case watchList = 3
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTap(_ cell: CollectionViewTableViewCell, viewController: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

