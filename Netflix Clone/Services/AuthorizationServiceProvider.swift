//
//  AuthorizationServiceProvider.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 26/09/22.
//

import Foundation
import Combine

final class AuthorizationServiceProvider {
    private var cancellables = Set<AnyCancellable>()
    static let shared = AuthorizationServiceProvider()
    private var authorizationState: AuthorizationState = .unauthorized
    private var error: String?
    var user: User?
    var sessionId: String?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return formatter
    }()
    
    func getCredentialState(handler: @escaping (_ authState: AuthorizationState, _ error: String?) -> Void) {
        let user = UserDefaults.standard.value(forKey: "currentUser") as? [String : String]
        
        guard let user = user else {
            handler(.unauthorized, "User not available")
            return
        }
        
        let tokenExpireDateString = user["expiresAt"]!
        let tokenExpireDate = dateFormatter.date(from: tokenExpireDateString)!
        
        guard Date() < tokenExpireDate else {
            handler(.unauthorized, "Request token expired")
            return
        }
        
        sessionId = user["sessionId"]!
       
        if self.user == nil {
            LoginViewModel().getUserAccount()
                .sink { completion in
                    if case let .failure(error) = completion {
                        LoginViewController().showAlert(title: "Account Error", message: error.localizedDescription)
                    }
                } receiveValue: { [weak self] user in
                    self?.user = user
                    self?.authorizationState = .authorized
                    handler(.authorized, nil)
                }
                .store(in: &cancellables)
        }
    }
}

enum AuthorizationState {
    case authorized
    case unauthorized
}
