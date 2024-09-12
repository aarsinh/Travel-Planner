//
//  Plan.swift
//  Day Out
//
//  Created by Aarav Sinha on 02/09/24.
//

import Foundation

struct Plan: Codable, Identifiable, Hashable {
    let id: String
    let type: String
    var name: String
    let startDate: Date
    var endDate: Date?
    var address: String?
    var email: String?
    var phone: String?
    var flightNumber: String?
    var route: String?
    var location: LocationCoordinates?
    var departureLocation: LocationCoordinates?
    var arrivalLocation: LocationCoordinates?
}

struct LocationCoordinates: Codable, Hashable {
    let latitude: Double
    let longitude: Double
}
