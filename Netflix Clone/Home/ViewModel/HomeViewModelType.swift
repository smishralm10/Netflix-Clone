//
//  HomeViewModelType.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 02/11/22.
//

import Foundation
import Combine

struct HomeViewModelInput {
    let appear: AnyPublisher<Void, Never>
    let selection: AnyPublisher<Int, Never>
    let addToList: AnyPublisher<(Int, Bool), Never>
}

enum HomeTitleState {
    case loading
    case success([TitleCollection])
    case failure(Error)
}

extension HomeTitleState: Equatable {
    static func == (lhs: HomeTitleState, rhs: HomeTitleState) -> Bool {
        switch(lhs, rhs) {
        case(.loading, .loading): return true
        case(.success(let lshTitle), .success(let rhsTitle)): return lshTitle == rhsTitle
        case(.failure, .failure): return true
        default: return false
        }
    }
}

typealias HomeViewModelOutput = AnyPublisher<HomeTitleState, Never>

protocol HomeViewModelType: AnyObject {
    func transform(input: HomeViewModelInput) -> HomeViewModelOutput
}

