//
//  TitleViewModeltype.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 27/10/22.
//

import Foundation
import Combine

struct TitleDetailsViewModelInput {
    let appear: AnyPublisher<Void, Never>
}

enum TitleDetailsState {
    case loading
    case success(Title)
    case failure(Error)
}

extension TitleDetailsState: Equatable {
    static func == (lhs: TitleDetailsState, rhs: TitleDetailsState) -> Bool {
        switch(lhs, rhs) {
        case(.loading, .loading): return true
        case(.success(let lshTitle), .success(let rhsTitle)): return lshTitle == rhsTitle
        case(.failure, .failure): return true
        default: return false
        }
    }
}

typealias TitleDetailsViewModelOutput = AnyPublisher<TitleDetailsState, Never>

protocol TitleDetailsViewModelType: AnyObject {
    func transform(input: TitleDetailsViewModelInput) -> TitleDetailsViewModelOutput
}
