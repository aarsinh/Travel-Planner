//
//  TripView.swift
//  Day Out
//
//  Created by Aarav Sinha on 22/08/24.
//

import SwiftUI

struct TripView: View {
    @State var selectedTrip: Trip

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: TripViewModel
    @State private var addingPlans = false
    @State private var showDeleteAlert = false
    @State private var tripPlans: [Plan] = []
    @State private var tripId: String = ""
    @State private var saveState: SaveState = .idle

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMMM, yyyy"
        return formatter
    }
    
    var groupedPlans: [String: [Plan]] {
        Dictionary(grouping: selectedTrip.plans) { plan in
            plan.startDate.formatted(date: .complete, time: .omitted)
        }
    }
    
    var sortedDates: [String] {
        groupedPlans.keys.compactMap { dateString in
            dateFormatter.date(from: dateString)
        }
        .sorted()
        .compactMap { date in
            dateFormatter.string(from: date)
        }
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(selectedTrip.startDate != selectedTrip.endDate ? "\(selectedTrip.startDate) - \(selectedTrip.endDate)" : "\(selectedTrip.startDate)")
                                    .font(.title3)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            if selectedTrip.plans.isEmpty {
                                VStack {
                                    Text("No plans added yet")
                                        .bold()
                                    Text("Add Plans here")
                                    Button {
                                        addingPlans = true
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 7)
                                                .frame(height: 50)
                                                .padding(.horizontal)
                                            Text("Add Plans")
                                                .foregroundStyle(.white)
                                        }
                                    }
                                }
                                .padding(.top, 30)
                            } else {
                                ForEach(sortedDates, id: \.self) { date in
                                    VStack(alignment: .leading) {
                                        
                                        ZStack(alignment: .center) {
                                            Rectangle()
                                                .frame(height: 35)
                                                .foregroundStyle(.secondary.opacity(0.4))
                                            
                                            Text("\(date)")
                                                .font(.system(size: 14))
                                                .bold()
                                        }
                                        .padding(.top)
                                        
                                        ForEach(groupedPlans[date] ?? []) { plan in
                                            if plan.type == "Flight" {
                                                NavigationLink(destination: FlightDetailView(flight: plan, tripId: tripId)) {
                                                    PlanDetail(plan: plan)
                                                }
                                            } else {
                                                NavigationLink(destination: PlanDetailView(plan: plan, tripId: tripId)) {
                                                    PlanDetail(plan: plan)
                                                }
                                            }
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                        .onAppear {
                            Task {
                                if let tripId = try await viewModel.fetchTripId(by: selectedTrip.id) {
                                    self.tripId = tripId
                                    selectedTrip = try await viewModel.refreshTrip(id: tripId)
                                }
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $addingPlans) {
                        AddPlanView(trip: selectedTrip)
                            .onDisappear {
                                Task {
                                    if let tripId = try await viewModel.fetchTripId(by: selectedTrip.id) {
                                        selectedTrip = try await viewModel.refreshTrip(id: tripId)
                                        tripPlans = selectedTrip.plans
                                    }
                                }
                            }
                    }
                }
                
                .navigationTitle(selectedTrip.tripName)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            NavigationLink(destination: MapView(plans: selectedTrip.plans)) {
                                Label("Map View", systemImage: "map")
                            }
                            .disabled(selectedTrip.plans.isEmpty)
                            
                            Button(role: .destructive) {
                                showDeleteAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
                .alert("Are you sure?", isPresented: $showDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        saveState = .saving
                        Task {
                            if let tripId = try await viewModel.fetchTripId(by: selectedTrip.id) {
                                try await viewModel.deleteTrip(withId: tripId)
                                dismiss()
                                saveState = .saved
                            }
                        }
                    }
                } message: {
                    Text("Deleting this trip will permanently remove it from your trips.")
                }
                .overlay(
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button {
                                addingPlans = true
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 24, weight: .bold))
                                    .frame(width: 50, height: 50)
                                    .background(.blue)
                                    .clipShape(.circle)
                            }
                            .padding()
                        }
                    }
                )
            }
            
            if saveState == .saving {
                SavingView(text: "Deleting trip...")
            }
        }
    }
}

struct PlanDetail: View {
    let plan: Plan
    @EnvironmentObject var viewModel: TripViewModel
    var body: some View {
        HStack {
            Image(systemName: viewModel.planIcon(for: plan.type))
                .resizable()
                .frame(width: 40, height: 40)
                .padding(.horizontal, 7)
            
            VStack(alignment: .leading) {
                if plan.type == "Flight" {
                    if let route = plan.route, let flightNumber = plan.flightNumber {
                        Text(!route.isEmpty ? route : "Flight")
                            .font(.headline)
                        
                        Text("\(plan.name) \(flightNumber)")
                    }
                } else {
                    if let address = plan.address {
                        Text(plan.name)
                            .font(.headline)
                        
                        Text(address)
                    }
                }
            }
            .padding(.trailing, 7)
        }
        .padding(.top, 5)
    }
}

#Preview {
    TripView(selectedTrip: .example)
}
