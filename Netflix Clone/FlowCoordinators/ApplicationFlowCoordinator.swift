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
    
    typealias DependencyProvider = TitleSearchFlowCoordinatorDependencyProvider
    
    private let window: UIWindow
    private let dependencyProvider: DependencyProvider
    private var childCoordinators = [FlowCoordinator]()
    
    init(window: UIWindow, dependencyProvider: DependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }
    
    func start() {
        let searchFlowCoordinator = TitleSearchFlowCoordinator(window: window, dependencyProvider: dependencyProvider)
        childCoordinators = [searchFlowCoordinator]
        searchFlowCoordinator.start()
    }
    
    
}
