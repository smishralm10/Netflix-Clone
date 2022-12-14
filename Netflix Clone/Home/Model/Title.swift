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
    let posterPath: String?
    let overview: String
    let genreIds: [GenreId]?
    let genres: [Genre]?
    let releaseDate: String
    let isAdult: Bool?
    let runtime: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, genres, runtime, posterPath = "poster_path"
        case genreIds = "genre_ids"
        case releaseDate = "release_date"
        case isAdult = "adult"
    }
}

extension Title: Hashable {
    static func == (lhs: Title, rhs: Title) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
