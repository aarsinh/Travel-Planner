//
//  User.swift
//  Day Out
//
//  Created by Aarav Sinha on 22/07/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullName: String
    let email: String
    var profileImageURL: String?
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

extension User {
    static var MOCK_USER = User(id: "aarsin", fullName: "Aarav Sinha", email: "aarsinh112@gmail.com")
}
