//
//  Resource.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 30/08/22.
//

import Foundation


struct Resource<T: Decodable> {
    let url: URL
    let parameters: [String: CustomStringConvertible]
    var body: [String: Any]?
    var request: URLRequest? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        components.queryItems = parameters.keys.map { key in
            URLQueryItem(name: key, value: parameters[key]?.description)
        }
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        
        guard let body = body else {
            return request
        }
        
        let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = bodyData
            
        return request
    }

    init(url: URL, parameters: [String: CustomStringConvertible] = [:]) {
        self.url = url
        self.parameters = parameters
    }
    
    init(url: URL, parameters: [String: CustomStringConvertible] = [:], body: [String: Any]) {
        self.url = url
        self.parameters = parameters
        self.body = body
    }
}

extension Resource {
    
    static func trending(type: TitleType) -> Resource<Titles> {
        let url = APIConstants.baseURL.appendingPathComponent("/trending/\(type.rawValue)/week")
        let parameters: [String : CustomStringConvertible] = [
                    "api_key": APIConstants.apiKey,
                    "language": Locale.preferredLanguages[0]
                    ]
        return Resource<Titles>(url: url, parameters: parameters)
    }
    
    static func popular(type: TitleType) -> Resource<Titles> {
        let url = APIConstants.baseURL.appendingPathComponent("/\(type.rawValue)/popular")
        let parameters: [String: CustomStringConvertible] = [
            "api_key": APIConstants.apiKey
        ]
        return Resource<Titles>(url: url, parameters: parameters)
    }
    
    static func topRated(type: TitleType) -> Resource<Titles> {
        let url = APIConstants.baseURL.appendingPathComponent("/\(type.rawValue)/top_rated")
        let parameters: [String: CustomStringConvertible] = [
            "api_key": APIConstants.apiKey
        ]
        return Resource<Titles>(url: url, parameters: parameters)
    }
    
    static func upComing(type: TitleType) -> Resource<Titles> {
        let url = APIConstants.baseURL.appendingPathComponent("/\(type.rawValue)/upcoming")
        let parameters: [String: CustomStringConvertible] = [
            "api_key": APIConstants.apiKey,
            "region": "us"
        ]
        return Resource<Titles>(url: url, parameters: parameters)
    }
    
    static func discover(type: TitleType) -> Resource<Titles> {
        let url = APIConstants.baseURL.appendingPathComponent("/discover/\(type.rawValue)")
        let parameters: [String: CustomStringConvertible] = [
            "api_key": APIConstants.apiKey,
        ]
        return Resource<Titles>(url: url, parameters: parameters)
    }
    
    static func search(type: TitleType, query: String) -> Resource<Titles> {
        let url = APIConstants.baseURL.appendingPathComponent("/search/\(type.rawValue)")
        let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let parameters: [String: CustomStringConvertible] = [
            "api_key": APIConstants.apiKey,
            "query": query,
        ]
        return Resource<Titles>(url: url, parameters: parameters)
    }
    
    static func searchYoutube(query: String) -> Resource<YoutubeSearchResponse> {
        let url = APIConstants.youtubeBaseURL.appendingPathComponent("/search")
        let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let parameters: [String: CustomStringConvertible] = [
            "key": APIConstants.youtubeApiKey,
            "q": query,
        ]
        return Resource<YoutubeSearchResponse>(url: url, parameters: parameters)
    }
    
    static func generateRequestToken() -> Resource<LoginResponse> {
        let url = APIConstants.baseURL.appendingPathComponent("/authentication/token/new")
        let parameters: [String: CustomStringConvertible] = [
            "api_key": APIConstants.apiKey,
        ]
        return Resource<LoginResponse>(url: url, parameters: parameters)
    }
    
    static func validateTokenWithLogin(requestToken: String, username: String, password: String) -> Resource<LoginResponse> {
        let url = APIConstants.baseURL.appendingPathComponent("/authentication/token/validate_with_login")
        let parameters: [String: CustomStringConvertible] = [
            "api_key": APIConstants.apiKey,
        ]
        let body = [
            "username": username,
            "password": password,
            "request_token": requestToken
        ]
        return Resource<LoginResponse>(url: url, parameters: parameters, body: body)
    }
    
    static func createSession(requestToken: String) -> Resource<LoginResponse> {
        let url = APIConstants.baseURL.appendingPathComponent("/authentication/session/new")
        let parameters: [String: CustomStringConvertible] = [
            "api_key": APIConstants.apiKey,
        ]
        let body = [
            "request_token": requestToken
        ]
        return Resource<LoginResponse>(url: url, parameters: parameters, body: body)
    }
    
    static func getUserAccount() -> Resource<User> {
        let url = APIConstants.baseURL.appendingPathComponent("/account")
        let parameters: [String: CustomStringConvertible] = [
            "api_key": APIConstants.apiKey,
            "session_id": AuthorizationServiceProvider.shared.sessionId!
        ]
        
        return Resource<User>(url: url, parameters: parameters)
    }
    
    static func getWatchList() -> Resource<Titles> {
        let accountId = AuthorizationServiceProvider.shared.accountId!
        let url = APIConstants.baseURL.appendingPathComponent("/account/\(accountId)/watchlist/movies")
        let parameters: [String: CustomStringConvertible] = [
            "api_key": APIConstants.apiKey,
            "session_id": AuthorizationServiceProvider.shared.sessionId!
        ]
        return Resource<Titles>(url: url, parameters: parameters)
    }
    
    static func addTitleToWatchList(media_Id: Int, type: TitleType, add: Bool) -> Resource<WatchListResponse> {
        let accountId = AuthorizationServiceProvider.shared.accountId!
        let url = APIConstants.baseURL.appendingPathComponent("/account/\(accountId)/watchlist")
        let parameters: [String: CustomStringConvertible] = [
            "api_key": APIConstants.apiKey,
            "session_id": AuthorizationServiceProvider.shared.sessionId!
        ]
        
        let body : [String: Any] = [
            "media_type": type.rawValue,
            "media_id": media_Id,
            "watchlist": add
        ]
        
        return Resource<WatchListResponse>(url: url, parameters: parameters, body: body)
    }
    
    static func details(id: Int) -> Resource<Title> {
        let url = APIConstants.baseURL.appendingPathComponent("/movie/\(id)")
        let parameters: [String: CustomStringConvertible] = [
            "api_key": APIConstants.apiKey
        ]
        
        return Resource<Title>(url: url, parameters: parameters)
    }
}

enum TitleType: String {
    case movie = "movie"
    case tv = "tv"
}
