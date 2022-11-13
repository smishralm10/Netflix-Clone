//
//  HomeUseCase.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 02/11/22.
//

import Foundation
import Combine

protocol HomeUseCaseType: AnyObject {
    func popularTitles() -> AnyPublisher<Result<Titles, Error>, Never>
    
    func topRatedTitles() -> AnyPublisher<Result<Titles, Error>, Never>
    
    func trendingTitles() -> AnyPublisher<Result<Titles, Error>, Never>
    
    func watchlistTitles() -> AnyPublisher<Result<Titles, Error>, Never>
    
    func addToList(id: Int, shouldAdd: Bool) -> AnyPublisher<Result<WatchListResponse, Error>, Never>
    
}

final class HomeUseCase: HomeUseCaseType {
    private let networkService: NetworkServiceType
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
    
    func popularTitles() -> AnyPublisher<Result<Titles, Error>, Never> {
        return networkService.load(Resource<Titles>.popular(type: .movie))
            .map({ .success($0) })
            .catch { error -> AnyPublisher<Result<Titles, Error>, Never> in .publish(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func topRatedTitles() -> AnyPublisher<Result<Titles, Error>, Never> {
        return networkService.load(Resource<Titles>.topRated(type: .movie))
            .map({ .success($0) })
            .catch { error -> AnyPublisher<Result<Titles, Error>, Never> in .publish(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func trendingTitles() -> AnyPublisher<Result<Titles, Error>, Never> {
        return networkService.load(Resource<Titles>.trending(type: .movie))
            .map({ .success($0) })
            .catch { error -> AnyPublisher<Result<Titles, Error>, Never> in .publish(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func watchlistTitles() -> AnyPublisher<Result<Titles, Error>, Never> {
        return networkService.load(Resource<Titles>.getWatchList())
            .map({ .success($0) })
            .catch { error -> AnyPublisher<Result<Titles, Error>, Never> in .publish(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
                
    }
    
    func addToList(id: Int, shouldAdd: Bool) -> AnyPublisher<Result<WatchListResponse, Error>, Never> {
        return networkService.load(Resource<WatchListResponse>.addTitleToWatchList(media_Id: id, type: .movie, add: shouldAdd))
            .map({ .success($0) })
            .catch { error -> AnyPublisher<Result<WatchListResponse, Error>, Never>  in .publish(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
