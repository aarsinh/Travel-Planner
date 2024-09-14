//
//  SavingView.swift
//  DayOut
//
//  Created by Aarav Sinha on 14/09/24.
//

import SwiftUI

struct SavingView: View {
    let text: String
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
            
            VStack {
                ProgressView()
                Text(text)
                    .foregroundStyle(.white)
                    .bold()
            }
            .frame(width: 150, height: 150)
            .background(Color(.systemGray5))
            .clipShape(.rect(cornerRadius: 10))
        }
        .transition(.opacity)
    }
}

#Preview {
    SavingView(text: "Saving...")
}
