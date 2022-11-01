//
//  SearchResultsViewController.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 07/09/22.
//

import UIKit
import Combine

class SearchResultsViewController: UIViewController {
    
    private var searchResultsTitles = [Title]()
    private let selectListener: PassthroughSubject<Int, Never>
    
    private let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    init(selectListener: PassthroughSubject<Int, Never>) {
        self.selectListener = selectListener
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("Not Supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
    
    public func bind(with titles: [Title]) {
        searchResultsTitles = titles
        searchResultsCollectionView.reloadData()
    }
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResultsTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let posterPath = searchResultsTitles[indexPath.row].posterPath {
            cell.configure(model: posterPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectListener.send(searchResultsTitles[indexPath.row].id)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
