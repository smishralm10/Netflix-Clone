//
//  Movie.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 18/08/22.
//

import Foundation

struct TrendingMovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let title: String
    let posterPath: String
}
