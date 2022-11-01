//
//  DownloadFlowCoordinator.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 31/10/22.
//

import Foundation
import UIKit

class DownloadFlowCoordinator: FlowCoordinator {
    internal var navigationController: UINavigationController?
    fileprivate let dependencyProvider: ApplicationFlowCoordinatorDependencyProvider
   
    init(dependencyProvider: ApplicationFlowCoordinatorDependencyProvider) {
        self.dependencyProvider = dependencyProvider
    }
    
    func start() {
        let downloadNavigationController = dependencyProvider.titleDownloadNavigationController(navigator: self)
        self.navigationController = downloadNavigationController
    }
}

extension DownloadFlowCoordinator: TitleNavigator {
    func showDetails(forTitle Id: Int) {
        let controller = dependencyProvider.titleDetailController(Id)
        navigationController?.pushViewController(controller, animated: true)
    }
}
