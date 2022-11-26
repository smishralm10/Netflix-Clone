//
//  DetailViewController.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 09/09/22.
//

import UIKit
import Combine

class DetailViewController: UIViewController {
    
    private let viewModel: TitleDetailsViewModelType
    private let appear = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: TitleDetailsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("Not supported!")
    }
    
    private let contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .large
        return indicator
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.backgroundColor = .darkGray
        label.layer.cornerRadius = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let runtimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.sizeToFit()
        stackView.spacing = 10
        [yearLabel, ageLabel, runtimeLabel].forEach { label in
            stackView.addArrangedSubview(label)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        return button
    }()
    
    private let downloadButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        let button = UIButton()
        let image = UIImage(systemName: "arrow.down.to.line")
        configuration.title = "Download"
        configuration.image = image
        configuration.titlePadding = 10
        configuration.imagePadding = 10
        button.titleLabel?.textColor = .white
        button.tintColor = .darkGray
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        return button
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.sizeToFit()
        label.textColor = .white
        return label
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        [playButton, downloadButton, overviewLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoStackView)
        contentView.addSubview(verticalStackView)
        view.addSubview(contentView)
        view.addSubview(loadingIndicator)
        
        applyConstraints()
        bind(viewModel: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appear.send(())
    }
    
    private func bind(viewModel: TitleDetailsViewModelType) {
        let input = TitleDetailsViewModelInput(appear: appear.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)
            
        output.sink { [unowned self] state in
                self.render(state)
            }
            .store(in: &cancellables)
    }
    
    private func render(_ state: TitleDetailsState) {
        switch state {
        case .loading:
            contentView.isHidden = true
            loadingIndicator.startAnimating()
        case .success(let titleDetails):
            contentView.isHidden = false
            loadingIndicator.stopAnimating()
            show(titleDetails)
        case .failure(let error):
            contentView.isHidden = true
            loadingIndicator.stopAnimating()
            print("Failed to show detail \(error)")
        }
    }
    
    private func show(_ titleDetails: Title) {
        if let posterPath = titleDetails.posterPath {
            let url = ImageSize.original.url.appendingPathComponent(posterPath)
            posterImageView.sd_setImage(with: url)
        }
        titleLabel.text = titleDetails.title
        
        //populate title info
        yearLabel.text = String(titleDetails.releaseDate.split(separator: "-")[0])
        guard let isAdult = titleDetails.isAdult,
              let runtime = titleDetails.runtime  else {
            return
        }
        
        ageLabel.text = isAdult ? "16+" : "13+"
        let hours = runtime / 60
        let minutes = runtime % 60
        runtimeLabel.text = "\(hours)h\(minutes)m"
        
        overviewLabel.text = titleDetails.overview
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            posterImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            posterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            posterImageView.heightAnchor.constraint(equalToConstant: 250),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 12),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            //info stackView constraints
            infoStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            // vertical stackView constraints
            verticalStackView.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 10),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
        ])
    }
}
