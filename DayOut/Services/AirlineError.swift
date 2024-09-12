//
//  AirlineError.swift
//  Day Out
//
//  Created by Aarav Sinha on 07/09/24.
//

import Foundation

enum AirlineError: Error, LocalizedError {
    case invalidURL
    case serverError
    case invalidData
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL, please try again later"
        case .serverError:
            return "There was an error with the server. Please try again later"
            
        case .invalidData:
            return "Airline data is invalid, please try again later"
            
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
