//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 30/07/22.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    private var cancellables = [AnyCancellable]()
    private var viewModel: HomeViewModelType
    private var appear = PassthroughSubject<Void, Never>()
    private var selection = PassthroughSubject<Int, Never>()
    private var addToList = PassthroughSubject<(Int, Bool), Never>()
    
    private var collectionView: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<TitleCollection, Title>! = nil
    private var currentSnapshot: NSDiffableDataSourceSnapshot<TitleCollection, Title>! = nil
    static let titleElementKind = "title-element-kind"
    static let heroElementKind = "hero-element-kind"

    init(viewModel: HomeViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavBar()
        configureHierarchy()
        configureDataSource()
        bind(to: viewModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appear.send(())
    }
    
    private func configureUI() {
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func configureNavBar() {
        let image = UIImage(named: "netflixLogo")?.withRenderingMode(.alwaysOriginal).resizeTo(size: CGSize(width: 20, height: 35))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
    }
    
    private func bind(to viewModel: HomeViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        let input = HomeViewModelInput(appear: appear.eraseToAnyPublisher(), selection: selection.eraseToAnyPublisher(), addToList: addToList.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)
        output.sink { [unowned self] state in
            self.render(state)
        }
        .store(in: &cancellables)
    }
    
    private func render(_ state: HomeTitleState) {
        switch state {
        case .loading:
            print("Loading home feed")
        case .success(let titles):
            update(with: titles, animate: true)
        case .failure(let error):
            print(error)
        }
    }
}

fileprivate extension HomeViewController {
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 30
            
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: HomeViewController.titleElementKind, alignment: .top)
            
            
            let heroSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(450))
            let heroSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: heroSize, elementKind: HomeViewController.heroElementKind, alignment: .top)
            
            if sectionIndex == 0 {
                section.boundarySupplementaryItems = [titleSupplementary, heroSupplementary]
            } else {
                section.boundarySupplementaryItems = [titleSupplementary]
            }
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
}

extension HomeViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration
            <TitleCollectionViewCell, Title> { (cell, indexpath, title) in
                cell.bind(with: title.posterPath)
        }
        
        dataSource = UICollectionViewDiffableDataSource<TitleCollection, Title>(collectionView: collectionView, cellProvider:
            { (collectionView: UICollectionView, indexPath: IndexPath, title: Title) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: title)
        })
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: HomeViewController.titleElementKind) { supplementaryView, elementKind, indexPath in
            if let snapshot = self.currentSnapshot {
                let titleCategory = snapshot.sectionIdentifiers[indexPath.section]
                supplementaryView.label.text = titleCategory.header
            }
        }
        
        let heroSupplementaryRegistration = UICollectionView.SupplementaryRegistration
        <HeroUIView>(elementKind: HomeViewController.heroElementKind) { supplementaryView, elementKind, indexPath in
            guard var snapshot = self.currentSnapshot else {
                return
            }
            
            let titleCategory = snapshot.sectionIdentifiers[indexPath.section]
            let heroTitle = titleCategory.titles[0]
            supplementaryView.bind(with: heroTitle)
            let myList = snapshot.sectionIdentifiers[3]
            
            DispatchQueue.main.async {
                myList.titles.forEach { title in
                    if title.id == heroTitle.id {
                        supplementaryView.addButton.isSelected = true
                    } else {
                        supplementaryView.addButton.isSelected = false
                    }
                }
            }
            
            supplementaryView.infoButtonHandler  = { [weak self] in
                self?.selection.send(heroTitle.id)
            }
            
            supplementaryView.addButtonHandler = { [weak self] sender in
                if sender.isSelected {
                    snapshot.deleteItems([heroTitle])
                    self?.dataSource.apply(snapshot)
                    sender.isSelected.toggle()
                    self?.addToList.send((heroTitle.id, false))
                } else {
                    let myList = snapshot.sectionIdentifiers[3]
                    snapshot.appendItems([heroTitle], toSection: myList)
                    self?.dataSource.apply(snapshot, animatingDifferences: true)
                    sender.isSelected.toggle()
                    self?.addToList.send((heroTitle.id, true))
                }
            }
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            switch kind {
            case HomeViewController.heroElementKind:
                return self.collectionView.dequeueConfiguredReusableSupplementary(using: heroSupplementaryRegistration, for: index)
            case HomeViewController.titleElementKind:
                return self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
            default:
                return UICollectionReusableView()
            }
        }
    }
    
    func update(with collections: [TitleCollection], animate: Bool = true) {
        DispatchQueue.main.async {
            self.currentSnapshot = NSDiffableDataSourceSnapshot<TitleCollection, Title>()
            self.currentSnapshot.appendSections(collections)
            collections.forEach { collection in
                self.currentSnapshot.appendItems(collection.titles, toSection: collection)
            }
            self.dataSource.apply(self.currentSnapshot, animatingDifferences: animate)
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = dataSource.itemIdentifier(for: indexPath)
        if let title = title {
            self.selection.send(title.id)
        }
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
