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
    // Creates UIViewController to search for a title
    func titleSearchNavigationController(navigator: TitleSearchNavigator) -> UINavigationController
    
    // Creates UIViewController to show details for title
    func titleDetailController(_ id: Int) -> UIViewController
}
