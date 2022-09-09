//
//  DetailViewController.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 09/09/22.
//

import UIKit
import WebKit
import Combine

class DetailViewController: UIViewController {
    
    var titleDetail = PassthroughSubject<Title, Never>()
    var videoId = PassthroughSubject<VideoID, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
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
        view.addSubview(webView)
        view.addSubview(titleLabel)
        
        applyConstraints()
        configure()
    }

    private func configure() {
        titleDetail.sink { [weak self] title in
            self?.titleLabel.text = title.title
        }
        .store(in: &cancellables)
        
        videoId.sink { [weak self] videoId in
            let url = URL(string: "https://youtube.com/embed/\(videoId.videoId)")!
            self?.webView.load(URLRequest(url: url))
        }
        .store(in: &cancellables)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            webView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            webView.heightAnchor.constraint(equalToConstant: 300),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: -10),
        ])
    }
}
