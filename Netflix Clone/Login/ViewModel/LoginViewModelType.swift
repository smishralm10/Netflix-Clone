//
//  LoginViewModelType.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 14/11/22.
//

import Foundation
import Combine

struct LoginViewModelInput {
    let appear: AnyPublisher<Void, Never>
    
    let login: AnyPublisher<(String, String), Never>
}

enum LoginState {
    case idle
    case loading
    case invalidUsername(String)
    case invalidPassword(String)
    case success
    case failure(Error)
}

extension LoginState: Equatable {
    static func == (lhs: LoginState, rhs: LoginState) -> Bool {
        switch(lhs, rhs) {
        case(.loading, .loading): return true
        case(.invalidUsername(let lhsUsername), .invalidUsername(let rhsUsername)): return lhsUsername == rhsUsername
        case(.invalidPassword(let lhsPassword), .invalidPassword(let rhsPassword)): return lhsPassword == rhsPassword
        case(.success, .success): return true
        case(.failure, .failure): return true
        default: return false
        }
    }
}

typealias LoginViewModelOutput = AnyPublisher<LoginState, Never>

protocol LoginViewModelType: AnyObject {
    func transform(input: LoginViewModelInput) -> LoginViewModelOutput
}
