//
//  FlowCoordinator.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 22/10/22.
//

import Foundation

// A FlowCoordinator takes responsibility about coordinating view controllers and driving the flow in the application
protocol FlowCoordinator: AnyObject {
    
    // Starts the flow
    func start()
}
