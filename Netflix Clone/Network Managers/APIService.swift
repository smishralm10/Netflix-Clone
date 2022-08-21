//
//  File.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 17/08/22.
//

import Foundation

struct APICredentialProvider {
    static let apiKey = "802fcb321a47d6f99d3e410229ff2f35"
}

enum TMDBNetworkError: Error {
    case badURL
    case invalidRequest
    case invalidData
    case failedRequest
    case invalidResponse
}

class TMDBServices {
    static let shared = TMDBServices()
    
    private let host = "api.themoviedb.org"
    private let trendingMoviePath = "/3/trending/movie/week"
    
    func fetchTrendingMovies(completion: @escaping (Result<[Movie], TMDBNetworkError>) -> Void) {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = host
        urlComponent.path = trendingMoviePath
        urlComponent.queryItems = [
            URLQueryItem(name: "api_key", value: APICredentialProvider.apiKey)
        ]
        
        guard let url = urlComponent.url else {return completion(.failure(.badURL))}
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                
                guard error == nil else {
                    print("Failed Request: \(error!.localizedDescription)")
                    return completion(.failure(.failedRequest))
                }
                
                guard let data = data else {
                    print("No data returned from TMDB")
                    return completion(.failure(.invalidData))
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Invalid Response")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                guard response.statusCode == 200 else {
                    print("Failed response: \(response.statusCode)")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let movieData = try decoder.decode(TrendingMovieResponse.self, from: data)
                    completion(.success(movieData.results))
                } catch {
                    print("InvalidData: \(error.localizedDescription)")
                    completion(.failure(.invalidData))
                }
            }
            
        }.resume()
    }
}
