//
//  TripView.swift
//  Day Out
//
//  Created by Aarav Sinha on 24/07/24.
//

import SwiftUI

struct TripsListView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: TripViewModel
    @State private var trips: [Trip] = []
    @State private var presentAddScreen = false
    @State private var loadingState: LoadingState = .loading
    var body: some View {
        NavigationStack {
            VStack {
                if loadingState == .loading {
                    ProgressView()
                } else if trips.isEmpty {
                    ContentUnavailableView("No trips added yet", systemImage: "mappin.slash.circle.fill")
                } else {
                    ZStack {
                        List(trips, id: \.self) { trip in
                            NavigationLink(destination: TripView(selectedTrip: trip)) {
                                VStack(alignment: .leading) {
                                    Text(trip.tripName)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    
                                    Text(trip.startDate != trip.endDate ? "\(trip.startDate) - \(trip.endDate)" : "\(trip.startDate)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            .listRowSeparator(.hidden)
                            .foregroundStyle(.primary)
                        }
                        
                        
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal)
                    }
                    .padding(.top)
                    Spacer()
                }
            }
            .refreshable {
                Task {
                    trips = try await viewModel.loadTrips()
                }
            }
            .navigationTitle("Trips")
            .toolbar {
                Button(action: {
                    presentAddScreen = true
                }) {
                    Label("Add Trip", systemImage: "plus")
                }
            }
            .fullScreenCover(isPresented: $presentAddScreen, content: {
                AddTripView()
            })
            .onAppear {
                Task {
                    trips = try await viewModel.loadTrips()
                    loadingState = .loaded
                }
            }
            .onChange(of: presentAddScreen) { oldValue, newValue in
                if !newValue {
                    Task {
                        trips = try await viewModel.loadTrips()
                    }
                }
                viewModel.selectedLocation = ""
            }
        }
    }
}

#Preview {
    TripsListView()
}
