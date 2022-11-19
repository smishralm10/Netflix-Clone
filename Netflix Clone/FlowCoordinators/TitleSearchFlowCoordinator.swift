//
//  TitleSearchFlowCoordinator.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 22/10/22.
//

import Foundation
import UIKit

class TitleSearchFlowCoordinator: FlowCoordinator {
    internal var navigationController: UINavigationController?
    fileprivate let dependencyProvider: TitleSearchFlowCoordinatorDependencyProvider
    
    init(dependencyProvider: TitleSearchFlowCoordinatorDependencyProvider) {
        self.dependencyProvider = dependencyProvider
    }
    
    func start() {
        let searchNavigationController = dependencyProvider.titleSearchNavigationController(navigator: self)
        self.navigationController = searchNavigationController
    }
}

extension TitleSearchFlowCoordinator: TitleNavigator {
    
    func showDetails(forTitle Id: Int) {
        let controller = self.dependencyProvider.titleDetailController(Id)
        navigationController?.pushViewController(controller, animated: true)
    }
}
