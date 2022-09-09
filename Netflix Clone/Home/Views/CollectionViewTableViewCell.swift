//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 13/08/22.
//

import UIKit
import Combine

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTap(_ cell: CollectionViewTableViewCell, viewController: UIViewController)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    private let viewModel = DetailViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    static let identifer = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var titles = [Title]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    func configure(with titles: [Title]) {
        self.titles = titles
        self.collectionView.reloadData()
    }
    
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(model: self.titles[indexPath.row].posterPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let detailVC = DetailViewController()
        
        let titleDetail = titles[indexPath.row]
        
        viewModel.getYoutubeSearchResults(for: titleDetail.title)
        viewModel.$youtubeSearchResults
            .sink { items in
                if items.count > 0 {
                    detailVC.videoId.send(items[0].id)
                    detailVC.titleDetail.send(titleDetail)
                }
            }
            .store(in: &cancellables)
        
        self.delegate?.collectionViewTableViewCellDidTap(self, viewController: detailVC)
    }
}
