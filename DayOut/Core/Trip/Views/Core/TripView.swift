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
    @State private var editingTrip = false

    
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
                            }
                        }
                    }
                    .onAppear {
                        viewModel.loadPlans(for: selectedTrip)
                    }
                }
                .fullScreenCover(isPresented: $addingPlans) {
                    AddPlanView(trip: selectedTrip)
                        .onDisappear {
                            Task {
                                if let tripId = try await viewModel.fetchTripId(by: selectedTrip.id) {
                                    selectedTrip = try await viewModel.refreshTrip(id: tripId)
                                }
                            }
                            print("DEBUG: Plans: \(viewModel.selectedTripPlans)")
                        }
                }
                
                .fullScreenCover(isPresented: $editingTrip) {
                    AddTripView(isEditing: true)
                }
            }
            
            .navigationTitle(selectedTrip.tripName)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        NavigationLink(destination: MapView(plans: selectedTrip.plans)) {
                            Label("Map View", systemImage: "map")
                        }
                        Button {
                            editingTrip = true
                        } label: {
                            Label("Edit Details", systemImage: "square.and.pencil")
                        }
                        
                        Button(role: .destructive) {
                            Task {
                                if let tripId = try await viewModel.fetchTripId(by: selectedTrip.id) {
                                    try await viewModel.deleteTrip(withId: tripId)
                                }
                                dismiss()
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
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
    }
}

#Preview {
    TripView(selectedTrip: .example)
}
