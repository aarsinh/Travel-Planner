//
//  ContentView.swift
//  Day Out
//
//  Created by Aarav Sinha on 22/07/24.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    var body: some View {
        TabView {
            TripsListView()
                .tabItem { Label("Trips", systemImage: "airplane") }
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
            
        }
    }
}

#Preview {
    ContentView()
}
