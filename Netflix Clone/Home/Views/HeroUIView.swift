//
//  HeroUIView.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 13/08/22.
//

import UIKit

class HeroUIView: UIView {
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
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
    
    private let addButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let button = UIButton()
        let image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        config.image = image
        config.imagePadding = 10
        button.configuration = config
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 50)
        ])
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
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        return button
    }()
    
    private let infoButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let button = UIButton()
        let image = UIImage(systemName: "info.circle")?.withRenderingMode(.alwaysTemplate)
        config.image = image
        config.imagePadding = 10
        button.configuration = config
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 50)
        ])
        
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
            buttonsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
        ])
    }
   
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
