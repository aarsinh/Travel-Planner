//
//  UnderlineTextField.swift
//  Day Out
//
//  Created by Aarav Sinha on 29/07/24.
//

import SwiftUI

struct UnderlineTextField: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .overlay(Rectangle().frame(height: 2).padding(.top, 25).foregroundStyle(.teal))
            .padding(10)
            .padding(.trailing, 10)
    }
}

