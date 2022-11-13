//
//  HomeViewModel.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 24/08/22.
//

import Foundation
import Combine

class HomeViewModel: HomeViewModelType {
    private var cancellables = [AnyCancellable]()
    private weak var navigator: TitleNavigator?
    private let useCase: HomeUseCaseType
    
    
    init(navigator: TitleNavigator, useCase: HomeUseCaseType) {
        self.navigator = navigator
        self.useCase = useCase
    }
    
    func transform(input: HomeViewModelInput) -> HomeViewModelOutput {
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
        
        input.selection
            .sink { [weak self] titleId in
                self?.navigator?.showDetails(forTitle: titleId)
            }
            .store(in: &cancellables)
        
//        input.addToList
//            .sink { [weak self] (id, shouldAdd) in
//                self?.useCase.addToList(id: id, shouldAdd: shouldAdd)
//            }.store(in: &cancellables)
        
        let trendingTitles = input.appear
            .flatMapLatest { [unowned self] _ in self.useCase.trendingTitles() }
            .map({ result -> [Title] in
                if case let .success(titles) = result {
                    return titles.results
                } else {
                    return []
                }
            })
            .eraseToAnyPublisher()
        
        let topRatedTitles = input.appear
            .flatMapLatest { [unowned self] _ in self.useCase.topRatedTitles() }
            .map { result -> [Title] in
                if case let .success(titles) = result {
                    return titles.results
                } else {
                    return []
                }
            }
            .eraseToAnyPublisher()

        let popularTitles = input.appear
            .flatMapLatest { [unowned self] _ in self.useCase.popularTitles() }
            .map { result -> [Title] in
                if case let .success(titles) = result {
                    return titles.results
                } else {
                    return []
                }
            }
            .eraseToAnyPublisher()
        
        let watchlistTitles = input.appear
            .flatMapLatest { [unowned self] _ in self.useCase.watchlistTitles()}
            .map { result -> [Title] in
                if case let .success(titles) = result {
                    return titles.results
                } else {
                    return []
                }
            }
            .eraseToAnyPublisher()
        
        let homeFeedTitles = Publishers.CombineLatest4(trendingTitles, topRatedTitles, popularTitles, watchlistTitles)
            .map { (title1, title2, title3, title4) -> HomeTitleState in
                return .success(self.convert(with: [title1, title2, title3, title4]))
            }
            .eraseToAnyPublisher()
        
        let loading: HomeViewModelOutput = input.appear.map { _ in .loading }.eraseToAnyPublisher()
        
        return Publishers.Merge(loading, homeFeedTitles).eraseToAnyPublisher()
    }
}

extension HomeViewModel {
    private func convert(with titles: [[Title]]) -> [TitleCollection] {
        var i = 0
        let headers = ["Trending", "Top Rated", "Popular", "My List"]
        return titles.map { titles in
            let collection = TitleCollection(header: headers[i], titles: titles)
            i += 1
            return collection
        }
    }
}
