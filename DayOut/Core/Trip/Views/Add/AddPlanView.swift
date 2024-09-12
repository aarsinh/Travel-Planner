//
//  AddActivityView.swift
//  Day Out
//
//  Created by Aarav Sinha on 25/08/24.
//

import SwiftUI

struct AddPlanView: View {
    let trip: Trip
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: TripViewModel
    @State private var addingFlight = false
    @State private var addingAccommodation = false
    @State private var addingActivity = false
    @State private var addingRestaurant = false
    
    var body: some View {
        NavigationStack {
            VStack {
                CustomList(title: "Flight", imageSystemName: "airplane.circle.fill")
                    .onTapGesture {
                        addingFlight = true
                    }
                    .padding(.top, 10)
                
                CustomList(title: "Accommodation", imageSystemName: "bed.double.circle.fill")
                    .onTapGesture {
                        addingAccommodation = true
                    }
                
                CustomList(title: "Restaurant", imageSystemName: "fork.knife.circle.fill")
                    .onTapGesture {
                        addingRestaurant = true
                    }
                
                CustomList(title: "Activity", imageSystemName: "figure.walk.circle.fill")
                    .onTapGesture {
                        addingActivity = true
                    }
                Spacer()
            }
            .onChange(of: viewModel.shouldDismissToTripView, { oldValue, newValue in
                if newValue {
                    dismiss()
                }
            })
            
            .fullScreenCover(isPresented: $addingFlight) {
                AddFlightView(trip: trip)
            }
            
            .fullScreenCover(isPresented: $addingAccommodation) {
                AddAccommodationView(trip: trip)
            }
            
            .fullScreenCover(isPresented: $addingRestaurant) {
                AddRestaurantView(trip: trip)
            }
            .fullScreenCover(isPresented: $addingActivity) {
                AddActivityView(trip: trip)
            }
            .onAppear(perform: {
                viewModel.shouldDismissToTripView = false
            })
            .navigationBarTitle("Add a plan", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddPlanView(trip: .example)
}
