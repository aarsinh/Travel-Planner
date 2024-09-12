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
    @State private var phoneNumber = ""
    @State private var email = ""
    
    
    private var tripStart: Date {
        viewModel.dateFormatter.date(from: trip.startDate) ?? Date.now
    }
    
    private var tripEnd: Date {
        viewModel.dateFormatter.date(from: trip.endDate) ?? Date.now
    }
    
    var body: some View {
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
            
            TextField("Phone Number", text: $phoneNumber)
            TextField("Email", text: $email)
            
            Spacer()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") { dismiss() }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") { 
                            Task {
                                if let tripId = try await viewModel.fetchTripId(by: trip.id) {
                                    let plan = Plan(id: UUID().uuidString, type: "Restaurant", name: name, startDate: date, address: viewModel.address, email: email, phone: phoneNumber, location: LocationCoordinates(latitude: viewModel.selectedCoordinates.latitude, longitude: viewModel.selectedCoordinates.longitude))
                                    try await viewModel.updatePlans(tripId: tripId, plan: plan)
                                    viewModel.shouldDismissToTripView = true
                                }
                                
                            }
                            
                            dismiss()
                        }
                        .disabled(!formIsValid)
                    }
                }
        }
        .textFieldStyle(UnderlineTextField())
        .onAppear {
            self.dateText = trip.startDate
            self.date = viewModel.dateFormatter.date(from: dateText) ?? Date.now
            viewModel.address = ""
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
