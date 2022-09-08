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
        return URLRequest(url: url)
    }

    init(url: URL, parameters: [String: CustomStringConvertible] = [:]) {
        self.url = url
        self.parameters = parameters
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
}

enum TitleType: String {
    case movie = "movie"
    case tv = "tv"
}
