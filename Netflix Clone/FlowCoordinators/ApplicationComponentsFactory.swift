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
    func mainTabBarController(controllers: [UINavigationController]) -> UITabBarController {
        let tabBarController = MainTabBarController(controllers: controllers)
        return tabBarController
    }
    
    func titleDownloadNavigationController(navigator: TitleNavigator) -> UINavigationController {
        let viewController = UIViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        return navigationController
    }
    
    func comingSoonNavigationController(navigator: TitleNavigator) -> UINavigationController {
        let useCase = ComingSoonUseCase(networkService: self.networkService)
        let viewModel = ComingSoonViewModel(useCase: useCase, navigator: navigator)
        let viewController = ComingSoonViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = UIImage(systemName: "play.circle")
        return navigationController
    }
    
    func homeNavigationController(navigator: TitleNavigator) -> UINavigationController {
        let viewController = UIViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = UIImage(systemName: "house")
        return navigationController
    }
    
    func titleSearchNavigationController(navigator: TitleNavigator) -> UINavigationController {
        let useCase = SearchTitleUseCase(networkService: self.networkService)
        let viewModel  = SearchViewModel(useCase: useCase, navigator: navigator)
        let titleSearchViewController = SearchViewController(viewModel: viewModel)
        let titleSearchNavigationController = UINavigationController(rootViewController: titleSearchViewController)
        titleSearchViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        return titleSearchNavigationController
    }
    
    func titleDetailController(_ id: Int) -> UIViewController {
        let useCase = SearchTitleUseCase(networkService: self.networkService)
        let viewModel = DetailViewModel(titleId: id, useCase: useCase)
        let viewController = DetailViewController(viewModel: viewModel)
        return viewController
    }
}
