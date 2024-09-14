//
//  SearchAirlines.swift
//  Day Out
//
//  Created by Aarav Sinha on 03/09/24.
//

import SwiftUI

struct SearchAirlines: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: TripViewModel
    
    @State private var query = ""
    @State private var airlines: [Airline] = []
    @State private var loadingState: LoadingState = .loading
    var body: some View {
        ZStack {
            if loadingState == .loading && !query.isEmpty {
                HStack {
                    Spacer()
                    ProgressView()
                }
            }
            
            SearchBar(text: $query, placeholder: "Search Airlines")
                
        }
        
        List(airlines, id: \.self) { airline in
            Button {
                viewModel.selectedAirline = "\(airline.name)(\(airline.iata))"
                viewModel.airlineIcao = airline.icao
                dismiss()
            } label: {
                Text("\(airline.name)(\(airline.iata))")
            }
            .buttonStyle(.plain)
        }
        .onReceive(viewModel.$error, perform: { error in
            if error != nil {
                viewModel.showErrorAlert = true
            }
        })
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.error?.localizedDescription ?? "Unknown error."))
        }
            .scrollContentBackground(.hidden)
            .onChange(of: query){ _, newValue in
                if !newValue.isEmpty {
                    Task {
                        airlines = try await viewModel.fetchAirlines(query: newValue)
                        loadingState = .loaded
                    }
                } else {
                    airlines = []
                }
            }
            .onAppear {
                viewModel.selectedAirline = ""
                viewModel.airlineIcao = ""
                airlines = []
                query = ""
                viewModel.error = nil
            }
    }
}

#Preview {
    SearchAirlines()
}
