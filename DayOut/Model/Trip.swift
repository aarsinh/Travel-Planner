//
//  Trip.swift
//  Day Out
//
//  Created by Aarav Sinha on 09/08/24.
//

import Foundation

struct Trip: Codable, Hashable, Identifiable {
    var id: String
    let endDate: String
    let latitude: Double
    let longitude: Double
    let startDate: String
    let tripName: String
    var plans: [Plan]
    static let example = Trip(id: UUID().uuidString, endDate: "Aug 29, 2024", latitude: 0, longitude: 0, startDate: "Aug 22, 2024", tripName: "test", plans: [])
}


