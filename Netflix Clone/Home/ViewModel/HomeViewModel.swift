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
    @Published var popularMovies = [Title]()
    @Published var topRatedMovies = [Title]()
    
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
    
    func getPopularMovies() {
        TMDBServices.shared
            .load(Resource<[Title]>.popular(type: .movie))
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] titles in
                self?.popularMovies = titles.results
            }
            .store(in: &cancellables)
    }
    
    func getTopRatedMovies() {
        TMDBServices.shared
            .load(Resource<[Title]>.topRated(type: .movie))
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] titles in
                self?.topRatedMovies = titles.results
            }
            .store(in: &cancellables)
    }
}
