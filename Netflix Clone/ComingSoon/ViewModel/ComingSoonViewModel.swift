//
//  ComingSoonViewModel.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 04/09/22.
//

import Foundation
import Combine

class ComingSoonViewModel {
    private var cancellables = Set<AnyCancellable>()
    @Published var upComingMovies = [Title]()
    
    func getUpComingMovies() {
        NetworkService.shared
            .load(Resource<[Title]>.upComing(type: .movie))
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] titles in
                self?.upComingMovies = titles.results
            }
            .store(in: &cancellables)
    }
}

