//
//  SearchViewModel.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 07/09/22.
//

import Foundation
import Combine
import UIKit

final class SearchViewModel: TitleSearchViewModelType {
    private weak var navigator: TitleNavigator?
    private let useCase: SearchTitleUseCaseType
    private var cancellables: [AnyCancellable] = []
    
    init(useCase: SearchTitleUseCaseType, navigator: TitleNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: TitleSearchViewModelInput) -> TitleSearchViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        input.selection
            .sink { [unowned self] titleId in
                self.navigator?.showDetails(forTitle: titleId)
            }
            .store(in: &cancellables)
        
        let searchInput = input.search
            .debounce(for: .milliseconds(300), scheduler: Scheduler.mainScheduler)
            .removeDuplicates()
        
        let titles = searchInput
            .filter({ !$0.isEmpty })
            .flatMapLatest({ [unowned self] query in
                self.useCase.searchTitles(with: query, type: .movie)
            })
            .map({ result -> TitleSearchState in
                switch result {
                case .success(let titles) where titles.results.isEmpty:
                    return .noResults
                case .success(let titles):
                    return .success(titles.results)
                case .failure(let error):
                    return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        
        let discoverTitles = self.useCase.discoverTitles()
            .map({ result -> TitleSearchState in
                switch result {
                case .success(let titles):
                    return .idle(titles.results)
                case .failure(let error):
                    return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        
        let initialState: TitleSearchViewModelOutput = discoverTitles
        
        return Publishers.Merge(initialState, titles).eraseToAnyPublisher()
    }
}
