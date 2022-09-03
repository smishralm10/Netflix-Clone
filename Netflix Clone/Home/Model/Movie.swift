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
    
    enum CodingKeys: String, CodingKey {
        case id, title, posterPath = "poster_path"
    }
}
