//
//  HomeFlowCoordinator.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 31/10/22.
//

import Foundation
import UIKit

class HomeFlowCoordinator: FlowCoordinator {
    internal var navigationController: UINavigationController?
    fileprivate let dependencyProvider: ApplicationFlowCoordinatorDependencyProvider
    
    init(dependencyProvider: ApplicationFlowCoordinatorDependencyProvider) {
        self.dependencyProvider = dependencyProvider
    }
    
    func start() {
        let homeNavigationController = dependencyProvider.homeNavigationController(navigator: self)
        self.navigationController = homeNavigationController
    }
}

extension HomeFlowCoordinator: TitleNavigator {
    func showDetails(forTitle Id: Int) {
        let controller = dependencyProvider.titleDetailController(Id)
        navigationController?.pushViewController(controller, animated: true)
    }
}
