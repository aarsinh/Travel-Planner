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
    var departureCity: String?
    var arrivalCity: String?
    var location: LocationCoordinates?
    var departureLocation: LocationCoordinates?
    var arrivalLocation: LocationCoordinates?
}

struct LocationCoordinates: Codable, Hashable {
    let latitude: Double
    let longitude: Double
}

extension Plan {
    static let example = Plan(id: "first", type: "Flight", name: "Flight", startDate: Date.now, endDate: Date.now, address: "Address", email: "email@email.com", phone: "1010101010", flightNumber: "12", route: "HYD - BLR", departureCity: "Hyderabad", arrivalCity: "Bangalore", location: LocationCoordinates(latitude: 0, longitude: 0), departureLocation: LocationCoordinates(latitude: 0, longitude: 0), arrivalLocation: LocationCoordinates(latitude: 0, longitude: 0))
}
