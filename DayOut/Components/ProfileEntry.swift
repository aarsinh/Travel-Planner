//
//  ProfileEntry.swift
//  Day Out
//
//  Created by Aarav Sinha on 26/07/24.
//

import SwiftUI

struct ProfileEntry: View {
    let title: String
    let entry: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            Text(entry)
                .font(.headline)
        }
        .padding()
    }
}

#Preview {
    ProfileEntry(title: "Full name", entry: "Aarav Sinha")
}
