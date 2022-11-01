//
//  SearchTitleViewModelType.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 19/10/22.
//

import Foundation
import Combine

struct TitleSearchViewModelInput {
    let appear: AnyPublisher<Void, Never>
    let search: AnyPublisher<String, Never>
    let selection: AnyPublisher<Int, Never>
}

enum TitleSearchState {
    case idle([Title])
    case loading
    case success([Title])
    case noResults
    case failure(Error)
}

extension TitleSearchState: Equatable {
    static func == (lhs: TitleSearchState, rhs: TitleSearchState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.success(let lhsMovies), .success(let rhsMovies)): return lhsMovies == rhsMovies
        case (.noResults, .noResults): return true
        case (.failure, .failure): return true
        default: return false
        }
    }
}

typealias TitleSearchViewModelOutput = AnyPublisher<TitleSearchState, Never>

protocol TitleSearchViewModelType: AnyObject {
    func transform(input: TitleSearchViewModelInput) -> TitleSearchViewModelOutput
}


protocol TitleNavigator: AnyObject {
    func showDetails(forTitle Id: Int)
}
