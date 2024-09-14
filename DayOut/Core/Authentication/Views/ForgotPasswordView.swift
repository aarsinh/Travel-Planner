//
//  ForgotPasswordView.swift
//  Day Out
//
//  Created by Aarav Sinha on 24/07/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var userService: UserService
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var showSentAlert = false
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                
                InputView(text: $email, placeholder: "Enter your email address", textAutocapitalization: .never, keyboard: .emailAddress)
                
                Button {
                    Task {
                       try await userService.resetPassword(withEmail: email)
                    }
                    showSentAlert = true
                } label: {
                    Text("Continue")
                        .foregroundStyle(.white)
                        .frame(width: max(proxy.size.width - 45, 0), height: 50)
                        .background(.blue)
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(.top)
                }
                
                Spacer()
                
                NavigationLink {
                    SignUpView()
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        Text("Sign up")
                            .bold()
                    }
                    .font(.system(size: 15))
                }
                
                Spacer()
            }
            .alert("Email Sent!", isPresented: $showSentAlert) {
                Button("Back to Login") { dismiss() }
            } message: {
                Text("An email has been sent to your registered mail. Please change your psasword and login.")
            }
            .padding()
        }
    }
}

#Preview {
    ForgotPasswordView()
}
