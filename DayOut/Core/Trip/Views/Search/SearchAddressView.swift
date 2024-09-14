//
//  SearchAddressView.swift
//  Day Out
//
//  Created by Aarav Sinha on 06/09/24.
//

import SwiftUI
import CoreLocation

struct SearchAddressView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: TripViewModel
    @State private var loadingState: LoadingState = .loading
    
    var body: some View {
        SearchBar(text: $viewModel.queryFragment, placeholder: "Search Address")
        List(viewModel.searchResults, id: \.self) { result in
            Button(action: {
                viewModel.selectLocation(completion: result) { coordinates, address in
                    if let address = address, let coordinates = coordinates {
                        viewModel.address = address
                        viewModel.selectedCoordinates = coordinates
                    } else {
                        print("DEBUG: Couldn't search location")
                    }
                    
                    dismiss()
                }
                
            }) { Text("\(result.title), \(result.subtitle)") }
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
            viewModel.selectedCoordinates = CLLocationCoordinate2D()
        }
    }
}

#Preview {
    SearchAddressView()
}
