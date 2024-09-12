//
//  Day_OutApp.swift
//  Day Out
//
//  Created by Aarav Sinha on 22/07/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
      }
}

@main
struct Day_OutApp: App {
    @StateObject var userService = UserService()
    @StateObject var airlineService = AirlineService()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            let settingsViewModel = SettingsViewModel(userService: userService)
            let tripViewModel = TripViewModel(userService: userService, airlineService: airlineService)
            let authViewModel = AuthViewModel(userService: userService)
            if userService.userSession != nil {
               ContentView()
                    .environmentObject(settingsViewModel)
                    .environmentObject(tripViewModel)
            } else {
                LoginView()
                    .environmentObject(settingsViewModel)
                    .environmentObject(authViewModel)
            }
        }
        .environmentObject(userService)
        .environmentObject(airlineService)
    }
}
