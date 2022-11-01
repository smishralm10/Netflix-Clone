//
//  ComingSoonViewModel.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 04/09/22.
//

import Foundation
import Combine

class ComingSoonViewModel: ComingSoonViewModelType {
    private weak var navigator: TitleNavigator?
    private let useCase: ComingSoonUseCaseType
    private var cancellables = [AnyCancellable]()
    
    init(useCase: ComingSoonUseCaseType, navigator: TitleNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: ComingSoonViewModelInput) -> ComingSoonViewModelOutput {
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
        
        input.selection
            .sink { [unowned self] titleId in
                self.navigator?.showDetails(forTitle: titleId)
            }
            .store(in: &cancellables)
        
        let titles = input.appear
            .flatMapLatest { [unowned self] _ in
                self.useCase.comingSoon()
            }
            .map({ result -> ComingSoonTitleState in
                switch result {
                case .success(let titles): return .success(titles.results)
                case.failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        
        let loading: AnyPublisher<ComingSoonTitleState, Never> = input.appear.map({ _ in .loading }).eraseToAnyPublisher()
        
        return Publishers.Merge(loading, titles).removeDuplicates().eraseToAnyPublisher()
    }
}

