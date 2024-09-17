//
//  PlanDetailView.swift
//  DayOut
//
//  Created by Aarav Sinha on 13/09/24.
//

import SwiftUI

struct PlanDetailView: View {
    let plan: Plan
    let tripId: String
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: TripViewModel
    @State private var showAlert = false
    
    var startDate: String {
        viewModel.dateFormatter.string(from: plan.startDate)
    }
    
    var endDate: String {
        viewModel.dateFormatter.string(from: plan.endDate ?? plan.startDate)
    }
    
    var body: some View {
        NavigationStack {
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(plan.name)
                            .font(.title2)
                            .bold()
                        Text(plan.type)
                    }
                    .padding(.horizontal)
                    
                    ZStack(alignment: .leading) {
                        Text(startDate != endDate ? "\(startDate) - \(endDate)" : startDate)
                            .bold()
                            .padding(.horizontal)
                        
                        Rectangle()
                            .fill(.secondary.opacity(0.4))
                            .frame(height: 25)
                    }
                    
                    if plan.type == "Accommodation" {
                        VStack(alignment: .leading) {
                            Text("Check In")
                            Text(startDate)
                                .font(.title3)
                                .bold()
                                .padding(.bottom, 5)
                            
                            Text("Check Out")
                            Text(endDate)
                                .font(.title3)
                                .bold()
                        }
                        .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        if let phone = plan.phone, let address = plan.address, let email = plan.email, let website = plan.website {
                            if !phone.isEmpty {
                                let dash = CharacterSet(charactersIn: "-")
                                let cleanString = phone.trimmingCharacters(in: dash)
                                let tel = "tel://"
                                let formattedString = tel + cleanString
                                
                                Link(destination: URL(string: formattedString)!) {
                                    Label(phone, systemImage: "phone.fill")
                                }
                            }
                            
                            if !address.isEmpty {
                                let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                                
                                Link(destination: URL(string: "http://maps.apple.com/?q=\(encodedAddress)")!) {
                                    Label(address, systemImage: "mappin")
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            
                            if !website.isEmpty {
                                Link(destination: URL(string: website)!) {
                                    Label(website, systemImage: "globe")
                                }
                            }
                            
                            if !email.isEmpty {
                                Link(destination: URL(string: "mailto:\(email)")!) {
                                    Label(email, systemImage: "envelope.fill")
                                }
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                }
                
                Spacer()
                    
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        showAlert = true
                    }
                    .tint(.red)
                }
            }
            .alert("Are you sure?", isPresented: $showAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    Task {
                        try await viewModel.deletePlan(tripId: tripId, planId: plan.id)
                        dismiss()
                    }
                }
            } message: {
                Text("Deleting this plan will permanently remove it from your trip.")
            }
        }
    }
}

#Preview {
    PlanDetailView(plan: .example, tripId: "abcd")
}
