//
//  ComingSoonUseCase.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 01/11/22.
//

import Foundation
import Combine

protocol ComingSoonUseCaseType: AnyObject {
    func comingSoon() -> AnyPublisher<Result<Titles, Error>, Never>
}

final class ComingSoonUseCase: ComingSoonUseCaseType {
    private let networkService: NetworkServiceType
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
    
    func comingSoon() -> AnyPublisher<Result<Titles, Error>, Never> {
        return networkService.load(Resource<Titles>.upComing(type: .movie))
            .map{ .success($0) }
            .catch { error -> AnyPublisher<Result<Titles, Error>, Never> in .publish(.failure(error))}
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
