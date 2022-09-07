//
//  ImageLoader.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 25/08/22.
//

import Foundation

enum ImageSize {
    case small
    case original
    var url: URL {
        switch self {
        case .small:
            return APIConstants.smallImageURL
            
        case .original:
            return APIConstants.originalImageURL
        }
    }
}
