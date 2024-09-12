//
//  FirebaseError.swift
//  Day Out
//
//  Created by Aarav Sinha on 10/09/24.
//

import Foundation

enum FirebaseError: Error, LocalizedError {
    case invalidURL
    case invalidData
    case invalidUser
    case invalidCredentials
    case serverError
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL, please try again later"
        case.invalidData:
            return "Invalid data, please try again later"
        case .invalidUser:
            return "User information could not be obtained. Please try again later"
        case .invalidCredentials:
            return "Incorrect email or password entered. Please check and try again"
        case .serverError:
            return "Server error. Please try again later"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
