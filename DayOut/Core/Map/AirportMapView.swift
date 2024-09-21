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
    @State private var position: MapCameraPosition = .automatic
    var body: some View {
        Map(position: $position) {
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
        .mapStyle(.imagery)
        .onAppear {
            let region = MKCoordinateRegion(center: airportCoordinates, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            position = .region(region)
        }
    }
}

#Preview {
    AirportMapView(airportCoordinates: CLLocationCoordinate2D(latitude: 13.1989, longitude: 77.7069))
}
