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
        label.font = .systemFont(ofSize: 22, weight: .bold)
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

    override func viewDidLoad() {
        super.viewDidLoad()
       
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
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
        let url = ImageSize.original.url.appendingPathComponent(titleDetails.posterPath)
        posterImageView.sd_setImage(with: url)
        titleLabel.text = titleDetails.title
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
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
