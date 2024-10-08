//
//  ChangePasswordView.swift
//  DayOut
//
//  Created by Aarav Sinha on 14/09/24.
//

import SwiftUI

struct ChangePasswordView: View {
    let user: User
    @EnvironmentObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var oldPassword = ""
    @State private var newPassword = ""
    @State private var isOldPasswordSecure = true
    @State private var isNewPasswordSecure = true
    @State private var showErrorAlert = false
    @State private var loadingState: LoadingState = .idle
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                ZStack(alignment: .trailing) {
                    InputView(text: $oldPassword, placeholder: "Old Password", isSecureField: isOldPasswordSecure)
                    
                    Button {
                        isOldPasswordSecure.toggle()
                    } label: {
                        Image(systemName: isOldPasswordSecure ? "eye" : "eye.slash")
                            .buttonStyle(.plain)
                    }
                    .padding([.trailing, .bottom], 17)
                }
                .buttonStyle(.plain)
                
                ZStack(alignment: .trailing) {
                    InputView(text: $newPassword, placeholder: "New Password", isSecureField: isNewPasswordSecure)
                    
                    Button {
                        isNewPasswordSecure.toggle()
                    } label: {
                        Image(systemName: isNewPasswordSecure ? "eye" : "eye.slash")
                            .buttonStyle(.plain)
                    }
                    .padding([.trailing, .bottom], 17)
                }
                .buttonStyle(.plain)
                Button {
                    loadingState = .loading
                    Task {
                        try await viewModel.changePassword(email: user.email, oldPassword: oldPassword, newPassword: newPassword)
                        loadingState = .loaded
                    }
                    dismiss()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 7)
                            .frame(height: 50)
                            .padding(.horizontal)
                        Text("Change Password")
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
            .onReceive(viewModel.$error) { error in
                if error != nil {
                    showErrorAlert = true
                }
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.error?.localizedDescription ?? "Unknown error"))
            }
            
            if loadingState == .loading {
                SavingView(text: "Saving...")
            }
        }
    }
}

#Preview {
    ChangePasswordView(user: .MOCK_USER)
}
