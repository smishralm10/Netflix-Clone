//
//  LoginViewModel.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 26/09/22.
//

import Foundation
import Combine

final class LoginViewModel: LoginViewModelType {
    private var cancellables = [AnyCancellable]()
    private let useCase: LoginUseCaseType
    private var requestToken: String?
    private var expiresAt: String?
    private var sessionId: String?
    
    init(useCase: LoginUseCaseType) {
        self.useCase = useCase
    }
    
    func transform(input: LoginViewModelInput) -> LoginViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        input.appear
            .flatMapLatest {  [weak self] _ -> AnyPublisher<Result<LoginResponse, Error>, Never> in
                guard let self = self else {
                    return .publish(.failure(LoginError.failedRequest))
                }
                return self.useCase.getRequestToken() }
            .map { result -> String? in
                if case let .success(response) = result {
                    return response.requestToken
                }
                return nil
            }
            .sink { [weak self] requestToken in
                if let requestToken = requestToken {
                    self?.requestToken = requestToken
                }
            }
            .store(in: &cancellables)
        
        let loading = input.login.map { _ -> LoginState in .loading }.eraseToAnyPublisher()
        
        let userLogin = input.login
            .flatMapLatest { [weak self] (username, password) -> AnyPublisher<Result<LoginResponse, Error>, Never> in
                guard let self = self, let requestToken = self.requestToken else {
                    return .publish(.failure(LoginError.invalidRequestToken))
                }

                return self.useCase.validateToken(username: username, password: password, requestToken: requestToken)
            }
            .flatMap { [unowned self] result -> AnyPublisher<Result<LoginResponse, Error>, Never>  in
                switch result {
                case .success(let response):
                    guard let requestToken = response.requestToken,
                          let expiresAt = response.expiresAt else {
                        return .publish(.failure(LoginError.invalidCredentails))
                    }
                    self.requestToken = requestToken
                    self.expiresAt = expiresAt
                    return self.useCase.createSesssion(requestToken: requestToken)
                    
                case .failure(let error):
                    return .publish(.failure(error))
                }
            }
            .flatMap { [unowned self] result -> AnyPublisher<Result<User, Error>, Never> in
                switch result {
                case .success(let response):
                    guard let sessionId = response.sessionId else {
                        return .publish(.failure(LoginError.invalidSession))
                    }
                    AuthorizationServiceProvider.shared.sessionId = sessionId
                    self.sessionId = sessionId
                    return self.useCase.getUserAccount()
                case .failure(let error):
                    return .publish(.failure(error))
                }
            }
            .map { [unowned self] result -> LoginState in
                switch result {
                case .success(let user):
                    let userCredentails = UserCredentails(sessionID: self.sessionId!, accountID: user.id, username: user.username, requestToken: self.requestToken!)
                    AuthorizationServiceProvider.shared.setLoggedInUser(with: userCredentails, expiresAt: self.expiresAt!)
                    return .success
                case .failure(let error):
                    return .failure(error)
                }
            }
            .eraseToAnyPublisher()
       
        
        let initialState: LoginViewModelOutput = input.appear.map { _ -> LoginState  in .idle }.eraseToAnyPublisher()
        
        return Publishers.Merge3(initialState, loading, userLogin).removeDuplicates().eraseToAnyPublisher()
    }
}

enum LoginError: Error {
    case failedRequest
    case invalidRequestToken
    case invalidCredentails
    case invalidSession
}
