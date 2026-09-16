//
//  CustomError+Ext.swift
//  Core
//
//  Created by Baren Baruna Harahap on 16/09/26.
//

import Foundation

public enum DatabaseError: LocalizedError {
    case invalidInstance
    case requestFailed

    public var errorDescription: String? {
        switch self {
        case .invalidInstance:
            return "Database can't instance."
        case .requestFailed:
            return "Your request failed."
        }
    }
}

public enum URLError: LocalizedError {
    case invalidResponse
    case addressUnreachable(URL)

    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The server responded with an invalid response."
        case .addressUnreachable(let url):
            return "\(url.absoluteString) is unreachable."
        }
    }
}
