//
//  AuthorizationServiceProvider.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 26/09/22.
//

import Foundation

final class AuthorizationServiceProvider {
    static let shared = AuthorizationServiceProvider()
    private var authorizationState: AuthorizationState = .unauthorized
    private var error: String?
    private var _sessionId: String?
    var sessionId: String {
        get {
            return _sessionId!
        }
        
        set(sessionId) {
            _sessionId = sessionId
        }
    }
    
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
        authorizationState = .authorized
        handler(.authorized, nil)
    }
}

enum AuthorizationState {
    case authorized
    case unauthorized
}
