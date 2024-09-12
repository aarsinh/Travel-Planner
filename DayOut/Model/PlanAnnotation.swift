//
//  PlanAnnotation.swift
//  Day Out
//
//  Created by Aarav Sinha on 12/09/24.
//

import Foundation
import CoreLocation

struct PlanAnnotation: Identifiable {
    let id = UUID()
    let coordinates: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    var date: Date
}
