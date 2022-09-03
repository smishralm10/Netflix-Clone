//
//  HomeViewModel.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 24/08/22.
//

import Foundation
import Combine

class HomeViewModel {
    private var cancellables = Set<AnyCancellable>()
    @Published var trendingMovies = [Title]()
    
    func getTrendingMovies() {
        TMDBServices.shared
            .load(Resource<[Title]>.trending(type: .movie))
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] titles in
                self?.trendingMovies = titles.results
            }
            .store(in: &cancellables)
    }
}
