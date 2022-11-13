//
//  HeroUIView.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 13/08/22.
//

import UIKit
import Combine

class HeroUIView: UICollectionReusableView {
    static let reuseIdentifier = "hero-reuse-identifier"
    var addButtonHandler: ((_ sender: UIButton) -> Void)?
    var infoButtonHandler: (() -> Void)?
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var buttonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 80.0
        stackView.distribution = .fill
        [
            self.addButton,
            self.playButton,
            self.infoButton,
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var addButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let button = UIButton()
        let addImage = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        let addedImage = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
        config.imagePadding = 10
        config.background.backgroundColor = .clear
        button.configuration = config
        button.setImage(addImage, for: .normal)
        button.setImage(addedImage, for: .selected)
        button.tintColor = .white
        button.addTarget(self, action: #selector(self.addTitleToWatchList), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let playButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        let button = UIButton()
        let image = UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate)
        configuration.title = "Play"
        configuration.image = image
        configuration.titlePadding = 10
        configuration.imagePadding = 10
        button.tintColor = .white
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var infoButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let button = UIButton()
        let image = UIImage(systemName: "info.circle")?.withRenderingMode(.alwaysTemplate)
        config.image = image
        config.imagePadding = 10
        button.configuration = config
        button.tintColor = .white
        button.addTarget(self, action: #selector(self.didTapInfoButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(heroImageView)
        addGradient()
        addSubview(buttonsStack)
        applyStackViewConstraints()
    }
    
    func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    private func applyStackViewConstraints() {
        NSLayoutConstraint.activate([
            buttonsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(path: String) {
        let url = ImageSize.original.url.appendingPathComponent(path)
        heroImageView.sd_setImage(with: url)
    }
    
    
    @objc func addTitleToWatchList(_ sender: UIButton) {
        guard let handler = self.addButtonHandler else {
            return
        }
        
        handler(sender)
    }
    
    @objc func didTapInfoButton(_ sender: UIButton) {
        guard let handler = infoButtonHandler else {
            return
        }
        handler()
    }
}
