//
//  Route.swift
//  Day Out
//
//  Created by Aarav Sinha on 08/09/24.
//

import Foundation

struct Route: Codable {
    let response: FlightRoute
}

struct FlightRoute: Codable {
    let flightroute: LocationResponse
}
struct LocationResponse: Codable {
    let origin: LocationDetails
    let destination: LocationDetails
}

struct LocationDetails: Codable {
    let iataCode: String
    let latitude: Double
    let longitude: Double
    let municipality: String
    
    enum CodingKeys: String, CodingKey {
        case iataCode = "iata_code"
        case latitude
        case longitude
        case municipality
    }
}


