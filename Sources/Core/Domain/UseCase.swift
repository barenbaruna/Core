//
//  UseCase.swift
//  Core
//
//  Created by Baren Baruna Harahap on 16/09/26.
//

import Foundation
import Combine

public protocol UseCase {
    associatedtype Request
    associatedtype Response

    func execute(request: Request?) -> AnyPublisher<Response, Error>
}
