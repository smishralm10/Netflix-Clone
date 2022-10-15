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
    @Published var watchList = [Title]()
    
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
    
    func getWatchList() {
        TMDBServices.shared
            .load(Resource<[Title]>.getWatchList())
            .receive(on: RunLoop.main)
            .map({ titles in
                titles.results
            })
            .sink { completion in
                if case let .failure(error) =  completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] titles in
                self?.watchList = titles
            }
            .store(in: &cancellables)
    }
    
    func addToWatchList(media_Id: Int, type: TitleType, add: Bool) -> AnyPublisher<WatchListResponse, Error> {
         return TMDBServices.shared
            .load(Resource<WatchListResponse>.addTitleToWatchList(media_Id: media_Id, type: type, add: add))
            .receive(on: RunLoop.main)
            .map({ response in
                response
            })
            .eraseToAnyPublisher()
    }
    
    func addOrRemoveTitle(title: Title, add: Bool) {
        for (i, t) in self.watchList.enumerated() {
            
            if t.id == title.id {
                if add {
                    watchList.append(title)
                } else {
                    watchList.remove(at: i)
                }
            }
        }
    }
}
