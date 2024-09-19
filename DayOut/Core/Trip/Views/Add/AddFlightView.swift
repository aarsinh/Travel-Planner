//
//  AddFlightView.swift
//  Day Out
//
//  Created by Aarav Sinha on 01/09/24.
//

import SwiftUI

struct AddFlightView: View {
    let trip: Trip
    
    @EnvironmentObject var viewModel: TripViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showFlightUnavailableView = false
    @State private var departureDateText = ""
    @State private var departureDate = Date.now
    @State private var showDatePicker = false
    @State private var flightNumber = ""
    @State private var routeText = ""
    @State private var route: Route?
    @State private var isEditing = false
    @State private var typingTimer: Timer?
    @State private var depIata = ""
    @State private var arrIata = ""
    @State private var depAirport: [Airport] = []
    @State private var arrAirport: [Airport] = []
    @State private var saveState: SaveState = .idle
    
    private var tripStart: Date {
        viewModel.dateFormatter.date(from: trip.startDate) ?? Date.now
    }
    
    private var tripEnd: Date {
        viewModel.dateFormatter.date(from: trip.endDate) ?? Date.now
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack(spacing: 0.1) {
                    CustomText(text: "Departure Date*")
                    TextField("Departure Date", text: $departureDateText)
                        .disabled(true)
                        .onTapGesture {
                            showDatePicker.toggle()
                        }
                    
                    if showDatePicker {
                        DatePicker("", selection: $departureDate, in: tripStart...tripEnd, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .padding()
                            .onChange(of: departureDate) { oldValue, newValue in
                                departureDateText = viewModel.dateFormatter.string(from: departureDate)
                                showDatePicker = false
                            }
                    }
                    
                }
                
                ZStack {
                    NavigationLink(destination: SearchAirlines()) {
                        HStack {
                            Text("Search Airlines View")
                                .opacity(0)
                            Spacer()
                        }
                    }
                    
                    TextField("Airline*", text: $viewModel.selectedAirline)
                        .disabled(true)
                    
                }
                
                TextField("Flight Number*", text: $flightNumber)
                    .onChange(of: flightNumber, { oldValue, newValue in
                        if !newValue.isEmpty {
                            routeText = ""
                            route = nil
                            typingTimer?.invalidate()
                            typingTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
                                Task {
                                    do {
                                        let route = try await viewModel.fetchRoute(airlineIcao: viewModel.airlineIcao, flightNumber: flightNumber)
                                        await MainActor.run {
                                            self.route = route
                                            depIata = route.response.flightroute.origin.iataCode
                                            arrIata = route.response.flightroute.destination.iataCode
                                            routeText = "\(depIata) - \(arrIata)"
                                        }
                                    } catch {
                                        await MainActor.run {
                                            showFlightUnavailableView = true
                                        }
                                    }
                                }
                            })
                        }
                    })
                
                if route != nil {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Route")
                                .bold()
                            
                            Text(routeText)
                        }
                        
                        Spacer()
                    }
                    .padding()
                } else if showFlightUnavailableView {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Route")
                                .bold()
                            
                            Text("Flight details unavailable")
                        }
                        .padding()
                        Spacer()
                    }
                }
                
                Spacer()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel") { dismiss() }
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Save") {
                                Task {
                                    saveState = .saving
                                    if let tripId = try await viewModel.fetchTripId(by: trip.id)  {
                                        depAirport = try await viewModel.fetchAirport(iataCode: depIata)
                                        arrAirport = try await viewModel.fetchAirport(iataCode: arrIata)
                                        
                                        let plan = Plan(id: UUID().uuidString,
                                                        type: "Flight",
                                                        name: viewModel.selectedAirline,
                                                        startDate: departureDate,
                                                        flightNumber: flightNumber,
                                                        route: routeText,
                                                        departureCity: depAirport[0].city,
                                                        arrivalCity: arrAirport[0].city,
                                                        departureLocation: LocationCoordinates(latitude: Double(depAirport[0].latitude) ?? 0, longitude: Double(depAirport[0].longitude) ?? 0),
                                                        arrivalLocation: LocationCoordinates(latitude: Double(arrAirport[0].latitude) ?? 0, longitude: Double(arrAirport[0].longitude) ?? 0)
                                        )
                                        
                                        try await viewModel.updatePlans(tripId: tripId, plan: plan)
                                        viewModel.shouldDismissToTripView = true
                                        saveState = .saved
                                    }
                                    dismiss()
                                }
                            }
                            .disabled(!formIsValid)
                        }
                    }
                    .navigationBarTitle("Flight", displayMode: .inline)
            }
            .onReceive(viewModel.$error, perform: { error in
                if error != nil {
                    viewModel.showErrorAlert = true
                    saveState = .idle
                    flightNumber = ""
                }
            })
            .alert(isPresented: $viewModel.showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.error?.localizedDescription ?? "Unknown error."),
                    dismissButton: .default(Text("OK")) {
                        viewModel.error = nil
                        saveState = .idle
                        routeText = ""
                        route = nil
                    }
                )
            }
            .padding(.top)
            .onAppear {
                departureDateText = trip.startDate
                departureDate = viewModel.dateFormatter.date(from: departureDateText) ?? Date.now
                viewModel.address = ""
                viewModel.selectedAirline = ""
                viewModel.error = nil
            }
            .textFieldStyle(UnderlineTextField())
            
            if saveState == .saving {
                SavingView(text: "Saving...")
            }
        }
    }
}

extension AddFlightView: AddPlanProtocol {
    var formIsValid: Bool {
        !viewModel.selectedAirline.isEmpty &&
        !departureDateText.isEmpty &&
        !flightNumber.isEmpty
    }
}
#Preview {
    AddFlightView(trip: .example)
}
