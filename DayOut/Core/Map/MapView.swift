//
//  MapView.swift
//  Day Out
//
//  Created by Aarav Sinha on 12/09/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var viewModel = MapViewModel()
    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
    let plans: [Plan]

    var body: some View {
        Map {
            ForEach(viewModel.planAnnotations) { annotation in
                Annotation(annotation.title, coordinate: annotation.coordinates) {
                    Text("Annotation")
                }
            }
        }
        .onAppear {
            viewModel.makeAnnotations(for: plans)
            position = .region(viewModel.region)
        }
    }
}

#Preview {
    MapView(plans: [])
}
