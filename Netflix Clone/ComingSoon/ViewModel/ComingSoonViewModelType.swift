//
//  ComingSoonViewModelType.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 01/11/22.
//

import Foundation
import Combine

struct ComingSoonViewModelInput {
    let appear: AnyPublisher<Void, Never>
    let selection: AnyPublisher<Int, Never>
}

enum ComingSoonTitleState {
    case loading
    case success([Title])
    case failure(Error)
}

extension ComingSoonTitleState: Equatable {
    static func == (lhs: ComingSoonTitleState, rhs: ComingSoonTitleState) -> Bool {
        switch(lhs, rhs) {
        case(.loading, .loading): return true
        case(.success(let lshTitle), .success(let rhsTitle)): return lshTitle == rhsTitle
        case(.failure, .failure): return true
        default: return false
        }
    }
}

typealias ComingSoonViewModelOutput = AnyPublisher<ComingSoonTitleState, Never>

protocol ComingSoonViewModelType: AnyObject {
    func transform(input: ComingSoonViewModelInput) -> ComingSoonViewModelOutput
}
