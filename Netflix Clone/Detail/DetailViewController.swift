//
//  DetailViewController.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 09/09/22.
//

import UIKit
import Combine

class DetailViewController: UIViewController {
    
    var titleDetail = PassthroughSubject<Title, Never>()
    
    private var cancellables = Set<AnyCancellable>()

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(posterImageView)
        view.addSubview(titleLabel)
        
        applyConstraints()
    }

    public func configure(with title: Title) {
            let url = ImageSize.original.url.appendingPathComponent(title.posterPath)
            self.posterImageView.sd_setImage(with: url)
            self.titleLabel.text = title.title
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            posterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            posterImageView.heightAnchor.constraint(equalToConstant: 250),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 12),
        ])
    }
}
