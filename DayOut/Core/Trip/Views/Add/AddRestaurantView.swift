//
//  AddRestaurantView.swift
//  Day Out
//
//  Created by Aarav Sinha on 02/09/24.
//

import SwiftUI

struct AddRestaurantView: View {
    let trip: Trip
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: TripViewModel
    
    @State private var name = ""
    @State private var dateText = ""
    @State private var date = Date.now
    @State private var showingDatePicker = false

    @State private var email = ""
    @State private var saveState: SaveState = .idle
    @State private var showErrorAlert = false
    
    private var tripStart: Date {
        viewModel.dateFormatter.date(from: trip.startDate) ?? Date.now
    }
    
    private var tripEnd: Date {
        viewModel.dateFormatter.date(from: trip.endDate) ?? Date.now
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                TextField("Restaurant Name", text: $name)
                
                VStack(spacing: 0.1) {
                    CustomText(text: "Date")
                    TextField("Date", text: $dateText)
                        .onTapGesture {
                            showingDatePicker.toggle()
                        }
                    
                    if showingDatePicker {
                        DatePicker("", selection: $date, in: tripStart...tripEnd, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .padding()
                            .onChange(of: date) { oldValue, newValue in
                                dateText = viewModel.dateFormatter.string(from: newValue)
                                showingDatePicker = false
                            }
                    }
                    
                }
                
                ZStack {
                    NavigationLink(destination: SearchAddressView()) {
                        HStack {
                            Text("Search Address View").opacity(0)
                            Spacer()
                        }
                    }
                    
                    TextField("Address", text: $viewModel.address)
                        .disabled(true)
                }
                
                TextField("Phone Number", text: $viewModel.phoneNumber)
                TextField("Website", text: $viewModel.website)
                TextField("Email", text: $email)
                
                Spacer()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel") { dismiss() }
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Save") {
                                Task {
                                    saveState = .saving
                                    if let tripId = try await viewModel.fetchTripId(by: trip.id) {
                                        let plan = Plan(id: UUID().uuidString, type: "Restaurant", name: name, startDate: date, address: viewModel.address, email: email, website: viewModel.website, phone: viewModel.phoneNumber, location: LocationCoordinates(latitude: viewModel.selectedCoordinates.latitude, longitude: viewModel.selectedCoordinates.longitude))
                                        try await viewModel.updatePlans(tripId: tripId, plan: plan)
                                        viewModel.shouldDismissToTripView = true
                                        saveState = .saved
                                    }
                                }
                                
                                dismiss()
                            }
                            .disabled(!formIsValid)
                        }
                    }
            }
            .onReceive(viewModel.$error, perform: { error in
                if error != nil {
                    viewModel.showErrorAlert = true
                }
            })
            .alert(isPresented: $viewModel.showErrorAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.error?.localizedDescription ?? "Unknown error."))
            }
            .textFieldStyle(UnderlineTextField())
            .onAppear {
                self.dateText = trip.startDate
                self.date = viewModel.dateFormatter.date(from: dateText) ?? Date.now
                viewModel.address = ""
                viewModel.phoneNumber = ""
                viewModel.website = ""
            }
            
            if saveState == .saving {
                SavingView(text: "Saving...")
            }
        }
    }
}

extension AddRestaurantView: AddPlanProtocol {
    var formIsValid: Bool {
        !name.isEmpty
    }
}
#Preview {
    AddRestaurantView(trip: .example)
}
