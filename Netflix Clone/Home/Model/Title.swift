//
//  Movie.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 18/08/22.
//

import Foundation

struct Titles: Decodable {
    let results: [Title]
}

struct Title: Decodable {
    let id: Int
    let title: String
    let posterPath: String
    let overview: String
    let genreIds: [Int]
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, posterPath = "poster_path"
        case genreIds = "genre_ids"
        case releaseDate = "release_date"
    }
}
