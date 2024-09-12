//
//  InputView.swift
//  Day Out
//
//  Created by Aarav Sinha on 22/07/24.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let placeholder: String
    var isSecureField = false
    var icon: Image?
    var textAutocapitalization: TextInputAutocapitalization?
    var keyboard: UIKeyboardType?
    
    var body: some View {
        VStack(alignment: .leading) {
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .frame(height: 22)
                    .textInputAutocapitalization(textAutocapitalization)
                    .keyboardType(keyboard ?? .default)
            } else {
               TextField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .frame(height: 22)
                    .textInputAutocapitalization(textAutocapitalization)
                    .keyboardType(keyboard ?? .default)
                    
            }
        }
        .padding(.bottom, 22)
        .textFieldStyle(RoundedTextField(icon: icon))
    }
}

struct RoundedTextField: TextFieldStyle {
    @State var icon: Image?
    func _body(configuration : TextField<Self._Label>) -> some View {
        HStack {
            if icon != nil {
                icon
                    .foregroundStyle(.black.opacity(0.7))
            }
            configuration
        }
            .padding(.vertical)
            .padding(.horizontal, 25)
            .frame(height: 50)
            .background(Color(UIColor.systemGray5))
            .clipShape(.capsule(style: .continuous))
    }
}

#Preview {
    InputView(text: .constant(""), placeholder: "Email")
}
