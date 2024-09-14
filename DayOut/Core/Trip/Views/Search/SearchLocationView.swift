//
//  SearchLocationView.swift
//  Day Out
//
//  Created by Aarav Sinha on 03/08/24.
//

import SwiftUI

struct SearchLocationView: View {
    @EnvironmentObject var viewModel: TripViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        SearchBar(text: $viewModel.queryFragment, placeholder: "Search Location")
        List(viewModel.searchResults, id: \.self) { result in
            Button(action: {
                viewModel.selectLocation(completion: result) { coordinates, _ in
                    if let coordinates = coordinates {
                        viewModel.selectedCoordinates = coordinates
                    } else {
                        print("DEBUG: Couldn't get coordinates for searched location")
                    }
                }
                dismiss()
            }) {
                Text(result.title)
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
        .onAppear {
            viewModel.searchResults = []
            viewModel.queryFragment = ""
        }
    }
}

#Preview {
    SearchLocationView()
}
