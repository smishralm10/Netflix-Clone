//
//  NetworkServiceType.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 18/10/22.
//

import Foundation
import Combine

protocol NetworkServiceType: AnyObject {

    @discardableResult
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error>
}
