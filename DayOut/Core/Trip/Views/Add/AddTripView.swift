//
//  AddTripView.swift
//  Day Out
//
//  Created by Aarav Sinha on 29/07/24.
//

import SwiftUI
import CoreLocation

struct AddTripView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: TripViewModel
    @State private var tripName = ""
    
    @State private var startDateText = ""
    @State var startDate = Date.now
    @State private var showStartDatePicker = false
    
    @State private var endDate = Date.now
    @State private var showEndDatePicker = false
    @State private var endDateText = ""
    
    var body: some View {
        NavigationStack {
            TextField("Trip Name*", text: $tripName)
                .padding(.top, 20)
            
            ZStack {
                NavigationLink(destination: SearchLocationView()) { 
                    HStack {
                        Text("Search Location View").opacity(0)
                        Spacer()
                    }
                }
                
                TextField("Destination*", text: $viewModel.selectedLocation)
                    .disabled(true)
            }
            
            VStack(spacing: 0.1) {
                CustomText(text: "Start Date")
                
                TextField("Start Date", text: $startDateText)
                    .disabled(true)
                    .onTapGesture {
                        showStartDatePicker.toggle()
                        showEndDatePicker = false
                    }
                    .onAppear {
                        startDateText = viewModel.dateFormatter.string(from: startDate)
                    }
                
                
                if showStartDatePicker {
                    DatePicker(
                        "",
                        selection: $startDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .padding()
                    .onChange(of: startDate) { oldValue, newValue in
                        startDateText = viewModel.dateFormatter.string(from: newValue)
                        showStartDatePicker = false
                    }
                }
            }
            
            VStack(spacing: 0.1) {
                CustomText(text: "End Date")
                
                TextField("End Date", text: $endDateText)
                    .disabled(true)
                    .onTapGesture {
                        showEndDatePicker.toggle()
                        showStartDatePicker = false
                    }
                    .onAppear {
                        endDateText = viewModel.dateFormatter.string(from: endDate)
                    }
                
                if showEndDatePicker {
                    DatePicker(
                        "",
                        selection: $endDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .padding()
                    .onChange(of: endDate) { oldValue, newValue in
                        endDateText = viewModel.dateFormatter.string(from: newValue)
                        showEndDatePicker = false
                    }
                }
            }
            Spacer()
                .navigationBarTitle("Add Trip", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") { dismiss() }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            Task {
                                try await viewModel.saveTrip(tripId: UUID().uuidString, tripName: tripName, coordinates: viewModel.selectedCoordinates, startDate: startDateText, endDate: endDateText, plans: [])
                                dismiss()
                            }
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
        .onAppear {
            viewModel.address = ""
        }
        .padding(10)
        .textFieldStyle(UnderlineTextField())
    }
}

extension AddTripView: AddFormProtocol {
    var formIsValid: Bool {
        !tripName.isEmpty &&
        !startDateText.isEmpty &&
        !endDateText.isEmpty &&
        !viewModel.selectedLocation.isEmpty
    }
}

#Preview {
    AddTripView()
}
