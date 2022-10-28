//
//  DetailViewModel.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 09/09/22.
//

import Foundation
import Combine

final class DetailViewModel : TitleDetailsViewModelType {
    let titleId: Int
    let useCase: SearchTitleUseCaseType
    
    init(titleId: Int, useCase: SearchTitleUseCaseType) {
        self.titleId = titleId
        self.useCase = useCase
    }
    
    func transform(input: TitleDetailsViewModelInput) -> TitleDetailsViewModelOutput {
        let titleDetails = input.appear
            .flatMapLatest { [unowned self] _ in
                self.useCase.titleDetails(with: titleId)
            }
            .map({ result -> TitleDetailsState in
                switch result {
                case .success(let title): return .success(title)
                case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        
        let loading: TitleDetailsViewModelOutput = input.appear.map({ _ in .loading }).eraseToAnyPublisher()
        
        return Publishers.Merge(loading, titleDetails).removeDuplicates().eraseToAnyPublisher()
    }
}
