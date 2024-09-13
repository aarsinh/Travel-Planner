//
//  PlanAnnotation.swift
//  Day Out
//
//  Created by Aarav Sinha on 12/09/24.
//

import Foundation
import CoreLocation

struct PlanAnnotation: Identifiable, Equatable, Hashable {
    let id = UUID()
    let coordinates: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    var date: Date
    var type: String
    var arrivalCoordinates: CLLocationCoordinate2D?
    
    static func ==(lhs: PlanAnnotation, rhs: PlanAnnotation) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let example = PlanAnnotation(coordinates: CLLocationCoordinate2D(latitude: 0, longitude: 0), title: "Aldona", subtitle: "Indigo", date: Date.now, type: "Restaurant")
}
