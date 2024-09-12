//
//  AddAccommodationView.swift
//  Day Out
//
//  Created by Aarav Sinha on 01/09/24.
//

import SwiftUI

struct AddAccommodationView: View {
    let trip: Trip
    
    @EnvironmentObject var viewModel: TripViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var checkinDate = Date.now
    @State private var checkinDateText = ""
    @State private var checkoutDate = Date.now
    @State private var checkoutDateText = ""
    @State private var accommodationName = ""
    @State private var showingCheckinDate = false
    @State private var showingCheckoutDate = false
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
            TextField("Accommodation Name", text: $accommodationName)
            
            VStack(spacing: 0.1) {
                CustomText(text: "Check-in Date")
                TextField("Checkin Date", text: $checkinDateText)
                    .disabled(true)
                    .onTapGesture {
                        showingCheckinDate.toggle()
                        showingCheckoutDate = false
                    }
                
                if showingCheckinDate {
                    DatePicker("", selection: $checkinDate, in: tripStart...tripEnd, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .padding()
                        .onChange(of: checkinDate) { oldValue, newValue in
                            checkinDateText = viewModel.dateFormatter.string(from: newValue)
                            showingCheckinDate = false
                        }
                }
            }
            
            VStack(spacing: 0.1) {
                CustomText(text: "Check-out Date")
                TextField("Checkout Date", text: $checkoutDateText)
                    .disabled(true)
                    .onTapGesture {
                        showingCheckoutDate.toggle()
                        showingCheckinDate = false
                    }
                
                if showingCheckoutDate {
                    DatePicker("", selection: $checkoutDate, in: tripStart...tripEnd, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .padding()
                        .onChange(of: checkoutDate) { oldValue, newValue in
                            checkoutDateText = viewModel.dateFormatter.string(from: newValue)
                            showingCheckoutDate = false
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
            TextField("Phone", text: $phoneNumber)
                .keyboardType(.decimalPad)
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
                                    let plan = Plan(id: UUID().uuidString, type: "Accommodation", name: accommodationName, startDate: checkinDate, endDate: checkoutDate, address: viewModel.address, email: email, phone: phoneNumber, location: LocationCoordinates(latitude: viewModel.selectedCoordinates.latitude, longitude: viewModel.selectedCoordinates.longitude))
                                    try await viewModel.updatePlans(tripId: tripId ,plan: plan)
                                    viewModel.shouldDismissToTripView = true
                                }
                            }
                            
                            dismiss()
                        }
                        .disabled(!formIsValid)
                    }
                }
                .navigationBarTitle("Accommodation", displayMode: .inline)
        }
        .padding(.top)
        .textFieldStyle(UnderlineTextField())
        .onAppear {
            checkinDateText = trip.startDate
            checkinDate = viewModel.dateFormatter.date(from: checkinDateText) ?? Date.now
            checkoutDateText = trip.endDate
            checkoutDate = viewModel.dateFormatter.date(from: checkoutDateText) ?? Date.now
            viewModel.address = ""
        }
    }
}

extension AddAccommodationView: AddPlanProtocol {
    var formIsValid: Bool {
        !accommodationName.isEmpty &&
        !checkinDateText.isEmpty 
    }
}

#Preview {
    AddAccommodationView(trip: .example)
}
