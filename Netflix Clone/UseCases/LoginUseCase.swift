//
//  LoginUseCase.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 13/11/22.
//

import Foundation
import Combine

protocol LoginUseCaseType: AnyObject {
    func getRequestToken() -> AnyPublisher<Result<LoginResponse, Error>, Never>
    
    func validateToken(username: String, password: String, requestToken: String) -> AnyPublisher<Result<LoginResponse, Error>, Never>
    
    func createSesssion(requestToken: String) -> AnyPublisher<Result<LoginResponse, Error>, Never>
    
    func getUserAccount() -> AnyPublisher<Result<User, Error>, Never>
}

final class LoginUseCase: LoginUseCaseType {
    private let networkService: NetworkServiceType
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
    
    func getRequestToken() -> AnyPublisher<Result<LoginResponse, Error>, Never> {
        return self.networkService.load(Resource<LoginResponse>.generateRequestToken())
            .map({ .success($0) })
            .catch{ error -> AnyPublisher<Result<LoginResponse, Error>, Never> in .publish(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func validateToken(username: String, password: String, requestToken: String) -> AnyPublisher<Result<LoginResponse, Error>, Never> {
        return self.networkService.load(Resource<LoginResponse>.validateTokenWithLogin(requestToken: requestToken, username: username, password: password))
            .map({ .success($0) })
            .catch{ error -> AnyPublisher<Result<LoginResponse, Error>, Never> in .publish(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func createSesssion(requestToken: String) -> AnyPublisher<Result<LoginResponse, Error>, Never> {
        return self.networkService.load(Resource<LoginResponse>.createSession(requestToken: requestToken))
            .map({ .success($0) })
            .catch{ error -> AnyPublisher<Result<LoginResponse, Error>, Never> in .publish(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func getUserAccount() -> AnyPublisher<Result<User, Error>, Never> {
        return self.networkService.load(Resource<User>.getUserAccount())
            .map({ .success($0) })
            .catch{ error -> AnyPublisher<Result<User, Error>, Never> in .publish(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
