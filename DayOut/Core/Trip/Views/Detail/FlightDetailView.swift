//
//  FlightDetailView.swift
//  DayOut
//
//  Created by Aarav Sinha on 14/09/24.
//

import SwiftUI
import CoreLocation

struct FlightDetailView: View {
    let flight: Plan
    let tripId: String
    @EnvironmentObject var viewModel: TripViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showAlert = false
    var body: some View {
        NavigationStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(flight.route ?? "Flight")
                        .font(.title2.bold())
                        .padding(.horizontal)
                    Text(flight.name)
                        
                        .padding(.horizontal)
                    
                    ZStack(alignment: .leading) {
                        Text(viewModel.dateFormatter.string(from: flight.startDate))
                            .bold()
                            .padding(.horizontal)
                        
                        Rectangle()
                            .fill(.secondary.opacity(0.4))
                            .frame(height: 25)
                    }
                    
                    HStack {
                        LineView()
                        VStack(alignment: .leading, spacing: 110) {
                            VStack(alignment: .leading) {
                                Text("Depart \(flight.departureCity!)")
                                NavigationLink(
                                    destination: AirportMapView(airportCoordinates: CLLocationCoordinate2D(latitude: flight.departureLocation?.latitude ?? 0,
                                                                                                           longitude: flight.departureLocation?.longitude ?? 0))
                                ) {
                                    Text("Show on Map")
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Arrive \(flight.arrivalCity!)")
                                NavigationLink(
                                    destination: AirportMapView(airportCoordinates: CLLocationCoordinate2D(latitude: flight.arrivalLocation?.latitude ?? 0,
                                                                                                           longitude: flight.arrivalLocation?.longitude ?? 0))
                                ) {
                                    Text("Show on Map")
                                }
                            }
                        }
                    }
                    .padding()
                    
                    
                    Spacer()
                }

                Spacer()
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(role: .destructive) {
                                showAlert = true
                            } label: {
                                Label("Delete Plan", systemImage: "trash")
                            }
                        }
                    }
                    .alert("Are you sure?", isPresented: $showAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            Task {
                                try await viewModel.deletePlan(tripId: tripId,planId: flight.id)
                            }
                            dismiss()
                        }
                    } message: {
                        Text("Deleting this plan will permanently remove it from your trip.")
                    }
            }
        }
    }
}

#Preview {
    FlightDetailView(flight: .example, tripId: "abcd")
}
