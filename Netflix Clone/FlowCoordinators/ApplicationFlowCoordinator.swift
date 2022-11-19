//
//  ApplicationFlowCoordinator.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 22/10/22.
//

import Foundation
import UIKit

// It takes the resposiblity of coordinating the viewControllers and driving the flow
class ApplicationFlowCoordinator: FlowCoordinator {
    
    typealias DependencyProvider = ApplicationFlowCoordinatorDependencyProvider
    
    private let window: UIWindow
    private let dependencyProvider: DependencyProvider
    private var childCoordinators = [FlowCoordinator]()
    
    init(window: UIWindow, dependencyProvider: DependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }
    
    func start() {
        let homeFlowCoordinator = HomeFlowCoordinator(dependencyProvider: dependencyProvider)
        let comingSoonFlowCoordinator = ComingSoonFlowCoordinator(dependencyProvider: dependencyProvider)
        let searchFlowCoordinator = TitleSearchFlowCoordinator(dependencyProvider: dependencyProvider)
        let downloadFlowCoordinator = DownloadFlowCoordinator(dependencyProvider: dependencyProvider)
        childCoordinators = [homeFlowCoordinator, comingSoonFlowCoordinator, searchFlowCoordinator, downloadFlowCoordinator]
        childCoordinators.forEach { flowCoordinator in
            flowCoordinator.start()
        }
    
        let controllers = [
            homeFlowCoordinator.navigationController!,
            comingSoonFlowCoordinator.navigationController!,
            searchFlowCoordinator.navigationController!,
            downloadFlowCoordinator.navigationController!
        ]
        
        AuthorizationServiceProvider.shared.getCredentialState { [weak self] authState, error in
            guard let self = self else {
                return
            }
            switch authState {
            case .authorized:
                let mainController = self.dependencyProvider.mainTabBarController(controllers: controllers)
                self.window.rootViewController = mainController
            case .unauthorized:
                self.window.rootViewController = self.dependencyProvider.loginViewController()
            }
        }
    }
}
