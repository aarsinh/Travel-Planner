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
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(flight.name)
                        .padding(.top, 35)
                        .padding(.horizontal)
                    
                    ZStack(alignment: .leading) {
                        Text("Date")
                            .bold()
                            .padding(.horizontal)
                        
                        Rectangle()
                            .fill(.secondary.opacity(0.4))
                            .frame(height: 25)
                    }
                    
                    VStack(alignment: .leading, spacing: 100) {
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
                        .padding(.horizontal)
                    
                    
                    Spacer()
                }

                Spacer()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Text(flight.route ?? "Flight")
                                .font(.title)
                                .bold()
                                .padding(.top, 75)
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Menu {
                                Button(role: .destructive) {
                                    
                                    dismiss()
                                } label: {
                                    Label("Delete Plan", systemImage: "trash")
                                }
                            } label: {
                                Label("Menu", systemImage: "ellipsis.circle")
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    FlightDetailView(flight: .example)
}
