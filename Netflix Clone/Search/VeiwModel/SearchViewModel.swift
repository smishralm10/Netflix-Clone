//
//  SearchViewModel.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 07/09/22.
//

import Foundation
import Combine

final class SearchViewModel {
    @Published var titles = [Title]()
    @Published var searchResultsTitles = [Title]()
    private var cancellables = Set<AnyCancellable>()
    
    func getDiscoverables() {
        TMDBServices.shared
            .load(Resource<[Title]>.discover(type: .movie))
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] titles in
                self?.titles = titles.results
            }
            .store(in: &cancellables)
    }
    
    func search(query: String, type: TitleType) {
        TMDBServices.shared
            .load(Resource<[Title]>.search(type: type, query: query))
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] titles in
                self?.searchResultsTitles = titles.results
            }
            .store(in: &cancellables)
    }
}
