//
//  TitleSearchFlowCoordinator.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 22/10/22.
//

import Foundation
import UIKit

class TitleSearchFlowCoordinator: FlowCoordinator {
    fileprivate let window: UIWindow
    fileprivate var searchNavigationController: UINavigationController?
    fileprivate let dependencyProvider: TitleSearchFlowCoordinatorDependencyProvider
    
    init(window: UIWindow, dependencyProvider: TitleSearchFlowCoordinatorDependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }
    
    func start() {
        let searchNavigationController = dependencyProvider.titleSearchNavigationController(navigator: self)
        window.rootViewController = searchNavigationController
        self.searchNavigationController = searchNavigationController
    }
}

extension TitleSearchFlowCoordinator: TitleSearchNavigator {
    
    func showDetails(forTitle Id: Int) {
        let controller = self.dependencyProvider.titleDetailController(Id)
        searchNavigationController?.pushViewController(controller, animated: true)
    }
}
