//
//  LoginView.swift
//  Day Out
//
//  Created by Aarav Sinha on 22/07/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = true
    @State private var showAlert = false
    @State private var loadingState: LoadingState = .idle
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            NavigationStack {
                GeometryReader { proxy in
                    ZStack {
                        VStack {
                            Spacer()
                            // form fields
                            VStack(alignment: .trailing, spacing: 15) {
                                InputView(text: $email, placeholder: "Email", icon: Image(systemName: "envelope"))
                                    .textInputAutocapitalization(.never)
                                
                                ZStack(alignment: .trailing) {
                                    InputView(text: $password, placeholder: "Password", isSecureField: isSecure, icon: Image(systemName: "lock"))
                                    
                                    Button {
                                        isSecure.toggle()
                                    } label: {
                                        Image(systemName: isSecure ? "eye" : "eye.slash")
                                            .buttonStyle(.plain)
                                    }
                                    .padding([.trailing, .bottom], 17)
                                }
                                .buttonStyle(.plain)
                                
                                // forgot password
                                NavigationLink {
                                    ForgotPasswordView()
                                        .navigationBarBackButtonHidden()
                                } label: {
                                    Text("Forgot Password?")
                                }
                                .font(.system(size: 15))
                            }
                            .padding(.horizontal)
                            
                            // sign in
                            Button {
                                loadingState = .loading
                                Task {
                                    try await viewModel.signin(withEmail: email, password: password)
                                    loadingState = .loaded
                                }
                            } label: {
                                HStack {
                                    Text("Sign In")
                                        .fontWeight(.semibold)
                                    Image(systemName: "arrow.right")
                                }
                                .foregroundStyle(.white)
                                .frame(width: max(proxy.size.width - 45, 0), height: 50)
                                .background(.blue)
                                .clipShape(.rect(cornerRadius: 10))
                                .padding(.top)
                            }
                            .disabled(!formIsValid)
                            .opacity(formIsValid ? 1 : 0.5)
                            
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
                        }
                        .frame(width: proxy.size.width, height: proxy.size.height)
                    }
                }
            }
            .onReceive(viewModel.$error) { error in
                if error != nil {
                    showAlert = true
                }
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(viewModel.error?.localizedDescription ?? "Unknown error")
            }
            
            if loadingState == .loading {
                SavingView(text: "Signing in...")
            }
        }
    }
}

// MARK: - AuthenticationFormProtocol

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && !password.isEmpty
        && email.contains("@")
        && password.count > 5
    }
}

#Preview {
    LoginView()
}
