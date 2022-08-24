//
//  File.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 17/08/22.
//

import Foundation
import Combine

struct APIConstants {
    static let baseURL = "https://api.themoviedb.org/3"
    static let apiKey = "802fcb321a47d6f99d3e410229ff2f35"
}

enum TMDBNetworkError: Error {
    case badURL
    case invalidRequest
    case invalidData
    case failedRequest
    case invalidResponse
    case unknown
}

class TMDBServices {
    static let shared = TMDBServices()
    
    private var cancellables = Set<AnyCancellable>()
    private let trendingMoviePath = "/trending/movie/week"
    
    func fetchTrendingMovies() -> Future<TrendingMovieResponse, Error> {
        var urlComponent = URLComponents(string: APIConstants.baseURL.appending(trendingMoviePath))
        urlComponent?.queryItems = [
            URLQueryItem(name: "api_key", value: APIConstants.apiKey)
        ]
        
        return Future<TrendingMovieResponse, Error> { [weak self] promise in
            guard let self = self, let url = urlComponent?.url else {
                return promise(.failure(TMDBNetworkError.badURL))
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw TMDBNetworkError.invalidResponse
                    }
                    
                    return data
                }
                .decode(type: TrendingMovieResponse.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink ( receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as TMDBNetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(TMDBNetworkError.unknown))
                        }
                    }
                }, receiveValue: { promise(.success($0)) })
                .store(in: &self.cancellables)
        }
    }
}
