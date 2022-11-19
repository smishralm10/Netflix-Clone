//
//  SearchTitleUseCase.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 18/10/22.
//

import Foundation
import Combine

protocol SearchTitleUseCaseType: AnyObject {
    
    func searchTitles(with name: String, type: TitleType) -> AnyPublisher<Result<Titles, Error>, Never>
    
    func titleDetails(with id: Int) -> AnyPublisher<Result<Title, Error>, Never>
    
    func discoverTitles() -> AnyPublisher<Result<Titles, Error>, Never>
}


final class SearchTitleUseCase: SearchTitleUseCaseType {
    
    private let networkService: NetworkServiceType
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
    
    func searchTitles(with name: String, type: TitleType) -> AnyPublisher<Result<Titles, Error>, Never> {
        return networkService.load(Resource<Titles>.search(type: type, query: name))
            .map{ .success($0) }
            .catch { error -> AnyPublisher<Result<Titles, Error>, Never> in .publish(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func titleDetails(with id: Int) -> AnyPublisher<Result<Title, Error>, Never> {
        return networkService.load(Resource<Title>.details(id: id))
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<Title, Error>, Never> in .publish(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func discoverTitles() -> AnyPublisher<Result<Titles, Error>, Never> {
        return networkService.load(Resource<Titles>.discover(type: .movie))
            .map{ .success($0) }
            .catch { error -> AnyPublisher<Result<Titles, Error>, Never> in .publish(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
