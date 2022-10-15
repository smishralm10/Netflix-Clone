//
//  Publisher.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 02/09/22.
//

import Foundation
import Combine
import UIKit

extension Publisher {

    static func empty() -> AnyPublisher<Output, Failure> {
        return Empty().eraseToAnyPublisher()
    }

    static func publish(_ output: Output) -> AnyPublisher<Output, Failure> {
        return Result.Publisher(output).eraseToAnyPublisher()
    }

    static func fail(_ error: Failure) -> AnyPublisher<Output, Failure> {
        return Fail(error: error).eraseToAnyPublisher()
    }
}
