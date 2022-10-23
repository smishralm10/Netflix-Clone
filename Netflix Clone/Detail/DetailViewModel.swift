//
//  DetailViewModel.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 09/09/22.
//

import Foundation
import Combine

final class DetailViewModel {
    @Published var youtubeSearchResults = [VideoElement]()
    var cancellables = Set<AnyCancellable>()
    
    func getYoutubeSearchResults(for query: String) {
        NetworkService.shared
            .load(Resource<[VideoElement]>.searchYoutube(query: query))
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] results in
                self?.youtubeSearchResults = results.items
            }
            .store(in: &cancellables)
    }
}
