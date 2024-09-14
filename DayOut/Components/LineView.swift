//
//  LineView.swift
//  DayOut
//
//  Created by Aarav Sinha on 14/09/24.
//

import SwiftUI

struct LineView: View {
    var body: some View {
        VStack {
            Image(systemName: "circle")
                .bold()
            Rectangle()
                .frame(width: 2, height: 150)
                .offset(y: -6)
            Image(systemName: "circle")
                .bold()
                .offset(y: -10)
        }
    }
}

#Preview {
    LineView()
}
