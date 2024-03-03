//
//  Errors.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/2/24.
//

import Foundation

enum NetworkingError: LocalizedError {
    
    case invalidURL
    case invalidResponse
    
    var failureReason: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid Response"
        }
    }
    
    var recoverSuggestion: String? {
        switch self {
        case .invalidURL:
            return "Check the URL and try again"
        default:
            return kDefaultRecoverySuggestion
        }
    }
}

enum NetworkError: LocalizedError {
    
    case unauthorized
    case resourceNotFound
    case unknown
    
    var failureReason: String? {
        switch self {
        case .unauthorized:
            return "Unauthorized"
        case .resourceNotFound:
            return "Resource Not Found"
        case .unknown:
            return "Unknown Error"
        }
    }
    
    var recoverSuggestion: String? {
        switch self {
        default:
            return kDefaultRecoverySuggestion
        }
    }
}

enum SerializationError: LocalizedError {
    
    case decodingFailed
    
    var failureReason: String? {
        switch self {
        case .decodingFailed:
            return "Failed to Decode"
        }
    }
    
    var recoverSuggestion: String? {
        switch self {
        case .decodingFailed:
            return "Check the CodingKeys of the model and try again"
        }
    }
}
