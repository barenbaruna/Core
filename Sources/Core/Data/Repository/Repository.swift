//
//  Repository.swift
//  Core
//
//  Created by Baren Baruna Harahap on 16/09/26.
//

import Foundation
import Combine

public protocol Repository {
    associatedtype Request
    associatedtype Response

    func execute(request: Request?) -> AnyPublisher<Response, Error>
}
