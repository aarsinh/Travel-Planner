//
//  MapViewModel.swift
//  Day Out
//
//  Created by Aarav Sinha on 12/09/24.
//

import Foundation
import SwiftUI
import MapKit

class MapViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    @Published var planAnnotations: [PlanAnnotation] = []
    
    func makeAnnotations(for plans: [Plan]) {
        planAnnotations = []
        
        for plan in plans {
            if plan.type == "Flight" {
                if let departureLocation = plan.departureLocation, let arrivalLocation = plan.arrivalLocation {
                    let annotation = PlanAnnotation(coordinates: CLLocationCoordinate2D(latitude: departureLocation.latitude, longitude: departureLocation.longitude),
                                                    title: plan.route ?? "Flight",
                                                    subtitle: plan.name,
                                                    date: plan.startDate,
                                                    type: plan.type,
                                                    arrivalCoordinates: CLLocationCoordinate2D(latitude: arrivalLocation.latitude, longitude: arrivalLocation.longitude))
                    
                    planAnnotations.append(annotation)
                }
            } else {
                if let latitude = plan.location?.latitude, let longitude = plan.location?.longitude {
                    let annotation = PlanAnnotation(coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), 
                                                    title: plan.name,
                                                    subtitle: plan.address ?? "",
                                                    date: plan.startDate,
                                                    type: plan.type)
                    
                    planAnnotations.append(annotation)
                }
            }
            
            if let firstAnnotation = planAnnotations.first {
                updateMapRegion(annotation: firstAnnotation)
            }
        }
    }
    
    func updateMapRegion(annotation: PlanAnnotation) {
        withAnimation(.easeInOut) {
            region = MKCoordinateRegion(center: annotation.coordinates, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        }
    }
}
