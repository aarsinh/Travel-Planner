//
//  SearchBar.swift
//  Day Out
//
//  Created by Aarav Sinha on 03/08/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
           
            ZStack(alignment: .trailing) {
                TextField(placeholder, text: $text)
                
                if !text.isEmpty {
                    Button(action: { self.text = "" }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                            .padding(.trailing, 25)
                    })
                }
            }
        }
        .padding(.horizontal)
        .textFieldStyle(UnderlineTextField())
    }
}

#Preview {
    SearchBar(text: .constant(""), placeholder: "Search Locations")
}
