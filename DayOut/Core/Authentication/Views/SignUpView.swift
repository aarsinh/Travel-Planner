//
//  SignUpView.swift
//  Day Out
//
//  Created by Aarav Sinha on 22/07/24.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var email = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = "" 
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                VStack {
                    Spacer()
                    // form fields
                    VStack(alignment: .trailing, spacing: 15) {
                        InputView(text: $email, placeholder: "Email", icon: Image(systemName: "envelope"))
                            .textInputAutocapitalization(.none)
                        
                        InputView(text: $fullName, placeholder: "Full Name", icon: Image(systemName: "person"))
                            .textInputAutocapitalization(.words)
                        
                        InputView(text: $password, placeholder: "Password", isSecureField: true, icon: Image(systemName: "lock"))
                        
                        ZStack(alignment: .trailing) {
                            InputView(text: $confirmPassword, placeholder: "Confirm Password", isSecureField: true)
                            
                            if !password.isEmpty && !confirmPassword.isEmpty {
                                if password == confirmPassword {
                                    Image(systemName: "checkmark.circle.fill")
                                        .imageScale(.large)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.green)
                                        .padding([.trailing, .bottom], 17)
                                } else {
                                    Image(systemName: "xmark.circle.fill")
                                        .imageScale(.large)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.red)
                                        .padding([.trailing, .bottom], 17)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                
                    Button {
                        Task {
                            try await viewModel.createUser(email: email, password: password, fullname: fullName)
                        }
                    } label: {
                        HStack {
                            Text("Sign Up")
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
                        LoginView()
                            .navigationBarBackButtonHidden()
                    } label: {
                        HStack(spacing: 3) {
                            Text("Already have an account?")
                            Text("Sign in")
                                .bold()
                        }
                        .font(.system(size: 15))
                    }
                    
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
    }
}

// MARK: - AuthenticationFormProtocol

extension SignUpView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && !password.isEmpty
        && email.contains("@")
        && password.count > 5
        && confirmPassword == password
        && !fullName.isEmpty
    }
}

#Preview {
    SignUpView()
}
