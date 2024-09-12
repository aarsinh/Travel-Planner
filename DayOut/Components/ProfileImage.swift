//
//  ProfileImage.swift
//  Day Out
//
//  Created by Aarav Sinha on 23/07/24.
//

import SwiftUI
import Kingfisher

struct ProfileImage: View {
    let user: User
    var body: some View {
        if let imageURL = user.profileImageURL {
            KFImage(URL(string: imageURL))
                .resizable()
                .scaledToFill()
                .frame(width: 65, height: 65)
                .clipShape(.circle)
        } else {
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .scaledToFit()
                .clipShape(.circle)
        }
    }
}

#Preview {
    ProfileImage(user: User.MOCK_USER)
}
