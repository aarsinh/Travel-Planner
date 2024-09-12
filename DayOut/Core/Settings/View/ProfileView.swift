//
//  ProfileView.swift
//  Day Out
//
//  Created by Aarav Sinha on 24/07/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var userService: UserService
    
    @State private var showDeleteAlert = false
    var body: some View {
            NavigationStack {
                if let user = userService.currentUser {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 1) {
                        Text("User Information")
                            .font(.title3.bold())
                            .padding([.horizontal, .top])
                        
                        List {
                            VStack(alignment: .leading) {
                                Text("Name")
                                    .foregroundStyle(.secondary)
                                Text(user.fullName)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Email Address")
                                    .foregroundStyle(.secondary)
                                Text(user.email)
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .scrollDisabled(true)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Account Management")
                            .font(.title3.bold())
                            .padding(.horizontal)
                        
                        List {
                            Text("Change Password")
                            Button(role: .destructive) {
                                showDeleteAlert = true
                            } label: {
                                HStack {
                                    Text("Delete account")
                                }
                            }

                        }
                        .scrollContentBackground(.hidden)
                        .scrollDisabled(true)
                    }
                    
                    Spacer()
                }
                .alert("Delete Account", isPresented: $showDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        Task {
                            try await settingsViewModel.delete()
                        }
                    }
                } message: {
                    Text("I understand that by deleting my account, all account information, including my trip data will be permanently deleted. This cannot be undone and my data cannot be recovered.")
                }
                .navigationBarTitle("Profile", displayMode: .inline)
            }
        
        }
    }
}
    
#Preview {
    ProfileView()
}
