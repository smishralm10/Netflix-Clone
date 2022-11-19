//
//  File.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 17/08/22.
//

import Foundation
import Combine

final class NetworkService: NetworkServiceType {
    static let shared = NetworkService()
    private let session: URLSession
    
    init(session: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)) {
        self.session = session
    }
    
    @discardableResult
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error> {
        
        guard let request = resource.request else {
            return .fail(TMDBNetworkError.invalidRequest)
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { _ in
                TMDBNetworkError.invalidRequest
            }
            .flatMap { data, response -> AnyPublisher<Data, Error> in
                guard let response = response as? HTTPURLResponse else {
                    return .fail(TMDBNetworkError.invalidResponse)
                }

                guard 200..<300 ~= response.statusCode else {
                    return .fail(TMDBNetworkError.dataLoadingError(statusCode: response.statusCode, data: data))
                }
                
                return .publish(data)
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

struct APIConstants {
    static let baseURL = URL(string: "https://api.themoviedb.org/3")!
    static let youtubeBaseURL = URL(string: "https://youtube.googleapis.com/youtube/v3")!
    static let apiKey = "802fcb321a47d6f99d3e410229ff2f35"
    static let youtubeApiKey = "AIzaSyC5W0c6dHOnAlGmPubY-i7IUM9mJo12Fzk"
    static let smallImageURL = URL(string: "https://image.tmdb.org/t/p/w500/")!
    static let originalImageURL = URL(string: "https://image.tmdb.org/t/p/original")!
}

enum TMDBNetworkError: Error {
    case badURL
    case invalidRequest
    case invalidData
    case failedRequest
    case invalidResponse
    case dataLoadingError(statusCode: Int, data: Data)
    case jsonDecodingError(error: Error)
    case unknown
}
