//
//  model.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 09/09/22.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: VideoID
}

struct VideoID: Codable {
    let kind: String
    let videoId: String
}
