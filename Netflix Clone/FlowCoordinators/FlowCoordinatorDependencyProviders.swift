//
//  FlowCoordinatorDependencyProviders.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 22/10/22.
//

import Foundation
import UIKit

// Defines methods to satisfy external dependecy of the ApplicationFlowCoordinators
protocol ApplicationFlowCoordinatorDependencyProvider: TitleSearchFlowCoordinatorDependencyProvider { }

protocol TitleSearchFlowCoordinatorDependencyProvider: AnyObject {
    // Creates UITabBarController to navigate between different tabs
    func mainTabBarController(controllers: [UINavigationController]) -> UITabBarController
    
    // Creates UIViewController to download a title
    func titleDownloadNavigationController(navigator: TitleNavigator) -> UINavigationController
    
    // Creates UIViewContoller for coming soon page
    func comingSoonNavigationController(navigator: TitleNavigator) -> UINavigationController
    
    // Creates UIViewController for home page
    func homeNavigationController(navigator: TitleNavigator) -> UINavigationController
    
    // Creates UIViewController to search for a title
    func titleSearchNavigationController(navigator: TitleNavigator) -> UINavigationController
    
    // Creates UIViewController to show details for title
    func titleDetailController(_ id: Int) -> UIViewController
    
    // Cretes view controller for user login
    func loginViewController() -> UIViewController
}
