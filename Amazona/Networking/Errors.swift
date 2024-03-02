//
//  Errors.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/2/24.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case invalidJSON
    case requestFailed
    case invalidInput
    
    var failureReason: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No Data"
        case .invalidJSON:
            return "Invalid JSON"
        case .requestFailed:
            return "Request Failed"
        case .invalidInput:
            return "Invalid Input"
        }
    }
    
    var recoverSuggestion: String? {
        switch self {
        case .invalidURL:
            return "Check the URL and try again"
        default:
            return "Try again, or contact help@foody.com"
        }
    }
}
