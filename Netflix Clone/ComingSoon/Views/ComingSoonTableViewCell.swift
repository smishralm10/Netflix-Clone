//
//  ComingSoonTableViewCell.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 04/09/22.
//

import UIKit
import Combine

class ComingSoonTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return "comingSoonTableViewCell"
    }
    
    private let posterImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18)
        label.textColor = .gray
        return label
    }()

    private let titleLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let overviewLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.sizeToFit()
        return label
    }()
    
    private let reminderButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let button = UIButton()
        let image = UIImage(systemName: "bell")?.withRenderingMode(.alwaysTemplate)
        config.image = image
        config.title = "Remind Me"
        config.titleAlignment = .center
        config.buttonSize = .mini
        config.imagePlacement = .top
        config.imagePadding = 5
        button.configuration = config
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        [
            self.dateLabel,
            self.reminderButton,
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var titleInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5.0
        stackView.distribution = .equalSpacing
        [
            self.titleLabel,
            self.overviewLabel,
            self.genreStackView
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let genreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImageView)
        contentView.addSubview(stackView)
        contentView.addSubview(titleInfoStackView)
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 250)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            posterImageView.heightAnchor.constraint(equalToConstant: 250),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            overviewLabel.heightAnchor.constraint(equalToConstant: 100),
            
            titleInfoStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleInfoStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5),
            titleInfoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
    
    func createLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.text = text
        label.sizeToFit()
        return label
    }
    
    func configureCell(with title: Title) {
        let url = ImageSize.original.url.appendingPathComponent(title.posterPath)
        posterImageView.sd_setImage(with: url)
        
        if let releaseDate = convertToTitleDateString(title.releaseDate) {
            dateLabel.text = "Coming on \(releaseDate)"
        }
        
        titleLabel.text = title.title
        overviewLabel.text = title.overview
    }
}
