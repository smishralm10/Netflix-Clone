//
//  HeroUIView.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 13/08/22.
//

import UIKit
import Combine

class HeroUIView: UIView {
    private var viewModel: HomeViewModel
    var cancellables = Set<AnyCancellable>()
    var title: Title?
    
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
    
    private let infoButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let button = UIButton()
        let image = UIImage(systemName: "info.circle")?.withRenderingMode(.alwaysTemplate)
        config.image = image
        config.imagePadding = 10
        button.configuration = config
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(frame: CGRect, viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        addSubview(heroImageView)
        addGradient()
        addSubview(buttonsStack)
        applyStackViewConstraints()
        
        viewModel.getWatchList()
        viewModel.getPopularMovies()
        viewModel.$watchList
            .sink { [weak self] titles in
                for title in titles {
                    if title.id == self?.title?.id {
                        self?.addButton.isSelected = true
                    }
                }
            }
            .store(in: &cancellables)
        
        viewModel.$popularMovies
            .sink { [weak self] titles in
                if titles.count > 0 {
//                    self?.setImage(path: titles[0].posterPath)
                    self?.title = titles[0]
                }
            }.store(in: &cancellables)
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
    
    func setImage(path: String) {
        let url = ImageSize.original.url.appendingPathComponent(path)
        heroImageView.sd_setImage(with: url)
    }
    
    
    @objc func addTitleToWatchList(_ sender: UIButton) {
        guard let title = title else {
            return
        }
        
        if sender.isSelected {
            viewModel.addToWatchList(media_Id: title.id, type: .movie, add: false)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print(error.localizedDescription)
                    }
                } receiveValue: { [weak self] response in
                    sender.isSelected.toggle()
                    self?.viewModel.addOrRemoveTitle(title: title, add: false)
                }
                .store(in: &cancellables)
            
        } else {
            viewModel.addToWatchList(media_Id: title.id, type: .movie, add: true)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print(error.localizedDescription)
                    }
                } receiveValue: { [weak self] response in
                    sender.isSelected.toggle()
                    self?.viewModel.addOrRemoveTitle(title: title, add: true)
                }
                .store(in: &cancellables)
        }
    }
}
