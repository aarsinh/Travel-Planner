//
//  ProfileViewModel.swift
//  Day Out
//
//  Created by Aarav Sinha on 23/07/24.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

@MainActor
class SettingsViewModel: ObservableObject {
    //MARK: - Properties
    @Published var showPhotosPicker: Bool = false
    @Published var profileImage: Image?
    @Published var selectedImage: PhotosPickerItem? {
        didSet {
            Task { try await loadImage(withItem: selectedImage) }
        }
    }
    
    private let userService: UserService
    
    @Published var error: Error?
    
    //MARK: - Initializer
    init(userService: UserService) {
        self.userService = userService
    }
    
    //MARK: - Functions
    func loadImage(withItem item: PhotosPickerItem?) async throws {
        guard let item = item else { return }
        guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: imageData) else { return }
        self.profileImage = Image(uiImage: uiImage)
        try await updateProfileImage(uiImage: uiImage)
    }
    
    private func updateProfileImage(uiImage: UIImage) async throws {
        guard let imageUrl = try await userService.uploadProfileImage(uiImage: uiImage) else { return }
        try await userService.updateUserProfileImage(withURL: imageUrl)
    }
        
    func signout() throws {
        do {
            try userService.signout()
        } catch {
            self.error = error
        }
        print("signed out")
    }
    
    func delete(email: String, password: String) async throws {
        do {
            try await userService.reauthenticateUser(email: email, password: password)
            try await userService.delete()
        } catch {
            self.error = error
        }
    }
    
    func changePassword(email: String, oldPassword: String, newPassword: String) async throws {
        do {
            try await userService.updatePassword(email: email, oldPassword: oldPassword, newPassword: newPassword)
        } catch {
            self.error = error
        }
    }
}
