//
//  DataSource.swift
//  Core
//
//  Created by Baren Baruna Harahap on 16/09/26.
//

import Foundation
import Combine

public protocol DataSource {
    associatedtype Request
    associatedtype Response

    func execute(request: Request?) -> AnyPublisher<Response, Error>
}
