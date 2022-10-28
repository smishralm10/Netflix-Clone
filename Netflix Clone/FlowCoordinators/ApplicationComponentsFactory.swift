//
//  FlowCoordinators.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 22/10/22.
//

import Foundation
import UIKit

final class ApplicationComponentsFactory {
    private let networkService: NetworkServiceType
    
    init(networkService: NetworkServiceType = NetworkService()) {
        self.networkService = networkService
    }
}

extension ApplicationComponentsFactory: ApplicationFlowCoordinatorDependencyProvider {
    func titleSearchNavigationController(navigator: TitleSearchNavigator) -> UINavigationController {
        let useCase = SearchTitleUseCase(networkService: self.networkService)
        let viewModel  = SearchViewModel(useCase: useCase, navigator: navigator)
        let titleSearchViewController = SearchViewController(viewModel: viewModel)
        let titleSearchNavigationController = UINavigationController(rootViewController: titleSearchViewController)
        return titleSearchNavigationController
    }
    
    func titleDetailController(_ id: Int) -> UIViewController {
        let useCase = SearchTitleUseCase(networkService: self.networkService)
        let viewModel = DetailViewModel(titleId: id, useCase: useCase)
        let viewController = DetailViewController(viewModel: viewModel)
        return viewController
    }
}
