//
//  model.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 27/09/22.
//

import Foundation

struct LoginResponse: Decodable {
    let success: Bool?
    let expiresAt: String?
    let requestToken: String?
    let statusMessage: String?
    let statusCode: Int?
    let sessionId: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
        case statusMessage = "status_message"
        case statusCode = "status_code"
        case sessionId = "session_id"
    }
}

struct WatchListResponse: Decodable {
    let statusCode: Int?
    let statusMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

struct User: Codable {
    let id: Int
    let name: String
    let username: String
}

extension User: Equatable {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
