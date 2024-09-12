//
//  CustomList.swift
//  Day Out
//
//  Created by Aarav Sinha on 01/09/24.
//

import SwiftUI

struct CustomList: View {
    var title: String
    var imageSystemName: String?
    var imageName: String?
    var body: some View {
        VStack {
            HStack {
                if let imageName = imageName {
                    Image(imageName)
                        .padding(.horizontal)
                    
                } else if let imageSystemName = imageSystemName {
                    Image(systemName: imageSystemName)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .tint(Color.teal)
                        .padding(.horizontal)
                        
                }
                
                Text(title)
                
                Spacer()
            }
            
            Divider()
        }
    }
}

#Preview {
    CustomList(title: "a")
}
