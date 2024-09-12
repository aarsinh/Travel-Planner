//
//  AuthViewMode.swift
//  Day Out
//
//  Created by Aarav Sinha on 23/07/24.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseFirestore

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    private var userService: UserService
    @Published var error: Error?
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func signin(withEmail email: String, password: String) async throws {
        do {
            try await userService.signin(email: email, password: password)
        } catch {
            self.error = error
        }
    }
    
    func createUser(email: String, password: String, fullname: String) async throws {
        do {
            try await userService.createUser(email: email, password: password, fullname: fullname)
        } catch {
            self.error = error
        }
    }
    
}

