//
//  ProfileView.swift
//  Day Out
//
//  Created by Aarav Sinha on 22/07/24.
//

import SwiftUI
import Kingfisher

struct SettingsView: View {
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    var body: some View {
        if let user = userService.currentUser {
            NavigationStack {
                List {
                    Section {
                        HStack {
                            Button {
                                settingsViewModel.showPhotosPicker.toggle()
                            } label: {
                                ZStack(alignment: .bottomTrailing) {
                                    ZStack {
                                        ProfileImage(user: user)
                                        if let profileImage = settingsViewModel.profileImage {
                                            profileImage
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 65, height: 65)
                                                .clipShape(.circle)
                                        }
                                    }
                                    
                                    Circle()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(Color(.darkGray))
                                        .overlay(
                                            Image(systemName: "camera.fill")
                                                .resizable()
                                                .frame(width: 8, height: 8)
                                                .foregroundStyle(.white)
                                        )
                                }
                            }
                            .buttonStyle(.plain)
                            
                            NavigationLink(destination: ProfileView()) {
                                VStack(alignment: .leading) {
                                    Text(user.fullName)
                                        .fontWeight(.semibold)
                                    
                                    Text(user.email)
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                }
                            }
                            
                        }
                    }

                    Section("Account") {
                        Button(role: .destructive) {
                            Task {
                                try settingsViewModel.signout()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .tint(.red)
                                Text("Sign out")
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .photosPicker(isPresented: $settingsViewModel.showPhotosPicker, selection: $settingsViewModel.selectedImage)
            }
        }
    }
}

#Preview {
    SettingsView()
}
