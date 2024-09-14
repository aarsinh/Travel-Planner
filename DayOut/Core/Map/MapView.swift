//
//  MapView.swift
//  Day Out
//
//  Created by Aarav Sinha on 12/09/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    let plans: [Plan]
    
    @ObservedObject var viewModel = MapViewModel()
    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
    @State private var selectedAnnotation: PlanAnnotation?

    var body: some View {
        ZStack {
            Map(position: $position) {
                ForEach(viewModel.planAnnotations) { annotation in
                    let isSelected = annotation.id == selectedAnnotation?.id
                    if annotation.type == "Flight", let arrivalCoordinates = annotation.arrivalCoordinates {
                        Annotation("", coordinate: arrivalCoordinates) {
                            MapAnnotationView(annotation: annotation)
                                .scaleEffect(isSelected ? 1 : 0.7)
                                .onTapGesture {
                                    selectedAnnotation = annotation
                                }
                        }
                    }
                    
                    Annotation("", coordinate: annotation.coordinates) {
                        MapAnnotationView(annotation: annotation)
                            .scaleEffect(isSelected ? 1 : 0.7)
                            .onTapGesture {
                                selectedAnnotation = annotation
                            }
                    }
                }
            }
            .onAppear {
                viewModel.makeAnnotations(for: plans)
                position = .region(viewModel.region)
                selectedAnnotation = viewModel.planAnnotations.first
            }
            
            VStack {
                Spacer()
                
                TabView(selection: $selectedAnnotation) {
                    ForEach(viewModel.planAnnotations) { annotation in
                        LocationDetailView(annotation: annotation)
                            .tag(annotation as PlanAnnotation?)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 180)
                .animation(.default, value: selectedAnnotation)
                .onChange(of: selectedAnnotation) { oldValue, newValue in
                    if let newAnnotation = newValue {
                        withAnimation {
                            viewModel.updateMapRegion(annotation: newAnnotation)
                            position = .region(viewModel.region)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MapView(plans: [])
}
