//
//  CustomText.swift
//  Day Out
//
//  Created by Aarav Sinha on 03/09/24.
//

import SwiftUI

struct CustomText: View {
    let text: String
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 15))
                .padding(.leading, 10)
            
            Spacer()
        }
    }
}

#Preview {
    CustomText(text: "a")
}
