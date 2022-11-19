//
//  TitleViewModel.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 10/11/22.
//

import Foundation

struct TitleCollection {
    let header: String
    let titles: [Title]
    let identifier = UUID()
}

extension TitleCollection: Hashable {
    static func == (lhs: TitleCollection, rhs: TitleCollection) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
