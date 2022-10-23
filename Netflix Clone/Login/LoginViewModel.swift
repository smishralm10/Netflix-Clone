//
//  LoginViewModel.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 26/09/22.
//

import Foundation
import Combine

final class LoginViewModel {
    
    func getRequestToken() ->  AnyPublisher<LoginResponse, Error> {
       return  NetworkService.shared
            .load(Resource<LoginResponse>.generateRequestToken())
            .receive(on: RunLoop.main)
            .mapError({ error in
                print(error.localizedDescription) as! Error
            })
            .eraseToAnyPublisher()
    }
    
    func validateToken(username: String, password: String, requestToken: String) -> AnyPublisher<LoginResponse, Error> {
        return NetworkService.shared
            .load(Resource<LoginResponse>.validateTokenWithLogin(requestToken: requestToken, username: username, password: password))
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func createSession(requestToken: String) -> AnyPublisher<LoginResponse, Error> {
        return NetworkService.shared
            .load(Resource<LoginResponse>.createSession(requestToken: requestToken))
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func getUserAccount() -> AnyPublisher<User, Error> {
        return NetworkService.shared
            .load(Resource<User>.getUserAccount())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
