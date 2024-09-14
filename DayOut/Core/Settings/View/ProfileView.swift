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
    @State private var showErrorAlert = false
    @State private var showPasswordAlert = false
    @State private var password = ""
    
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
                            NavigationLink(destination: ChangePasswordView(user: user)) {
                                HStack(spacing: 10) {
                                    Image(systemName: "key.fill")
                                    Text("Change Password")
                                }
                            }
                            .buttonStyle(.plain)
                            Button(role: .destructive) {
                                showDeleteAlert = true
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "x.circle.fill")
                                    Text("Delete account")
                                }
                            }

                        }
                        .scrollContentBackground(.hidden)
                        .scrollDisabled(true)
                    }
                    
                    Spacer()
                }
                .onReceive(settingsViewModel.$error, perform: { error in
                    if error != nil {
                        showErrorAlert = true
                    }
                })
                .alert(isPresented: $showErrorAlert) {
                    Alert(title: Text("Error"), message: Text("\(settingsViewModel.error?.localizedDescription ?? "Unknown Error")"))
                }
                .alert("Delete Account", isPresented: $showDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        Task {
                            showPasswordAlert = true
                        }
                    }
                } message: {
                    Text("I understand that by deleting my account, all account information, including my trip data will be permanently deleted. This cannot be undone and my data cannot be recovered.")
                }
                .alert("Confirm Password", isPresented: $showPasswordAlert) {
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                    
                    Button("Cancel", role: .cancel) { password = "" }
                    Button("Confirm", role: .destructive) {
                        Task {
                            try await settingsViewModel.delete(email: user.email, password: password)
                        }
                    }
                } message: {
                    Text("Please enter your password to confirm account deletion")
                }
                .navigationBarTitle("Profile", displayMode: .inline)
            }
        
        }
    }
}
    
#Preview {
    ProfileView()
}
