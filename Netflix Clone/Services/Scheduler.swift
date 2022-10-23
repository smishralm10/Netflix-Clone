//
//  Scheduler.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 18/10/22.
//

import Foundation

final class Scheduler {
    
    static var backgroundWorkScheduler: OperationQueue = {
        let operationQueue = OperationQueue()
            operationQueue.maxConcurrentOperationCount = 5
            operationQueue.qualityOfService = QualityOfService.userInitiated
            return operationQueue
    }()
    
    static let mainScheduler = RunLoop.main
}
