//
//  AirportMapView.swift
//  DayOut
//
//  Created by Aarav Sinha on 14/09/24.
//

import SwiftUI
import MapKit

struct AirportMapView: View {
    let airportCoordinates: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                                                   span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    var body: some View {
        Map {
            Annotation("", coordinate: airportCoordinates) {
                VStack {
                    Image(systemName: "airplane.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .font(.headline)
                    
                    Image(systemName: "triangle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .rotationEffect(.degrees(180))
                        .offset(y: -15)
                }
            }
        }
        .onAppear {
            region.center = airportCoordinates
        }
    }
}

#Preview {
    AirportMapView(airportCoordinates: CLLocationCoordinate2D(latitude: 13.1989, longitude: 77.7069))
}
