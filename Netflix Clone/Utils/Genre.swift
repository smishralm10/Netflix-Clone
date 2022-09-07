//
//  Genre.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 05/09/22.
//

import Foundation

class Genre {
    
    static func getGenresBy(ids: [Int]) -> Set<String> {
        var genres = Set<String>()
        for id in ids {
            let genre = getGenreBy(id: id)
            genres.insert(genre)
        }
        return genres
    }
    
    private static func getGenreBy(id: Int) -> String {
        switch id {
        case 28:
            return "Action"
        case 12:
            return "Adventure"
        case 16:
            return "Animation"
        case 35:
            return "Comedy"
        case 80:
            return "Crime"
        case 99:
            return "Documentry"
        case 18:
            return "Drama"
        case 10751:
            return "Family"
        case 14:
            return "Fantasy"
        case 36:
            return "History"
        case 27:
            return "Horror"
        case 10402:
            return "Music"
        case 9648:
            return "Mystery"
        case 10749:
            return "Romance"
        case 878:
            return "Science Fiction"
        case 10770:
            return "TV Movie"
        case 53:
            return "Thriller"
        case 10752:
            return "War"
        case 37:
            return "Western"
        default:
            return ""
        }
    }
}
