//
//  MapViewModel.swift
//  Day Out
//
//  Created by Aarav Sinha on 12/09/24.
//

import Foundation
import MapKit

class MapViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    @Published var planAnnotations: [PlanAnnotation] = []
    
    func makeAnnotations(for plans: [Plan]) {
        planAnnotations = []
        
        for plan in plans {
            if let latitude = plan.location?.latitude, let longitude = plan.location?.longitude {
                let annotation = PlanAnnotation(coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: plan.name, subtitle: plan.address ?? "", date: plan.startDate)
                planAnnotations.append(annotation)
            }
            
            if plan.type == "Flight" {
                if let departureLatitude = plan.departureLocation?.latitude, let departureLongitude = plan.departureLocation?.longitude {
                    let depAnnotation = PlanAnnotation(coordinates: CLLocationCoordinate2D(latitude: departureLatitude, longitude: departureLongitude), title: plan.route ?? "Flight", subtitle: plan.name, date: plan.startDate)
                    planAnnotations.append(depAnnotation)
                }
                
                if let arrivalLatitude = plan.arrivalLocation?.latitude, let arrivalLongitude = plan.arrivalLocation?.longitude {
                    let arrAnnotation = PlanAnnotation(coordinates: CLLocationCoordinate2D(latitude: arrivalLatitude, longitude: arrivalLongitude), title: plan.route ?? "Flight", subtitle: plan.name, date: plan.startDate)
                    
                    planAnnotations.append(arrAnnotation)
                }
            }
            
            if let firstAnnotation = planAnnotations.first {
                region.center = firstAnnotation.coordinates
            }
        }
    }
    
}
