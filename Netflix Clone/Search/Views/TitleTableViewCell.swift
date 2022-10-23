//
//  TitleTableViewCell.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 07/09/22.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    static var identifier: String {
        "TitleTableViewCell"
    }
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let button = UIButton()
        let image = UIImage(systemName: "play.circle")?.withRenderingMode(.alwaysTemplate)
        config.image = image?.resizeTo(size: CGSize(width: 40, height: 40))
        config.buttonSize = .medium
        config.imagePadding = 0
        button.configuration = config
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(posterImageView)
        addSubview(titleLabel)
        addSubview(playButton)
        
        applyContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func bind(to title: Title) {
        let url = ImageSize.small.url.appendingPathComponent(title.posterPath)
        posterImageView.sd_setImage(with: url)
        titleLabel.text = title.title
    }
    
    func applyContraints() {
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            posterImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 80),
            posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor, multiplier: 16/9),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -5),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 80),
            titleLabel.widthAnchor.constraint(equalToConstant: bounds.width - 150),
            
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
