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
    var accountId: Int?
    var sessionId: String?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return formatter
    }()
    
    func getCredentialState(handler: @escaping (_ authState: AuthorizationState, _ error: String?) -> Void) {
        let user = UserDefaults.standard.value(forKey: "currentUser") as? [String : Any]
        
        guard let user = user else {
            handler(.unauthorized, "User not available")
            return
        }
        
        let tokenExpireDateString = user["expiresAt"]! as? String
        let tokenExpireDate = dateFormatter.date(from: tokenExpireDateString!)!
        
        guard Date() < tokenExpireDate else {
            handler(.unauthorized, "Request token expired")
            return
        }
        
        sessionId = user["sessionId"]! as? String
        accountId = user["accountId"]! as? Int
        handler(.authorized, nil)
    }
    
    func setLoggedInUser(with credentails: UserCredentails, expiresAt date: String) {
        sessionId = credentails.sessionID
        accountId = credentails.accountID
        
        let userData: [String: Any] = [
            "sessionId": credentails.sessionID,
            "accountId": credentails.accountID,
            "username": credentails.username,
            "requestToken": credentails.requestToken,
            "expiresAt": date
        ]
        
        UserDefaults.standard.set(userData, forKey: "currentUser")
        authorizationState = .authorized
    }
}

struct UserCredentails {
    let sessionID: String
    let accountID: Int
    let username: String
    let requestToken: String
}

enum AuthorizationState {
    case authorized
    case unauthorized
}
