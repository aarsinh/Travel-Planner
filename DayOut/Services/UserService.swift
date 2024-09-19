//
//  UserService.swift
//  Day Out
//
//  Created by Aarav Sinha on 24/07/24.
//

import Firebase
import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import CoreLocation

@MainActor
class UserService: ObservableObject {
    
    //MARK: - Properties
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    private let db = Firestore.firestore()
    static var shared = UserService()
    
    //MARK: - Initializer
    init() {
        self.userSession = Auth.auth().currentUser
        print("user session set")
        Task {
            do {
                try await fetchUser()
            } catch {
                throw error
            }
        }
    }
    
    //MARK: - Functions
    func signin(email: String, password: String) async throws {
            do {
                let result = try await Auth.auth().signIn(withEmail: email, password: password)
                print("DEBUG: User signed in with UID: \(result.user.uid)")
                self.userSession = result.user
                print("DEBUG: userSession set to: \(String(describing: self.userSession))")
               try await fetchUser()
            } catch {
                throw FirebaseError.invalidCredentials
            }
        }
    
    
    func createUser(email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullname, email: email)
            guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            try await fetchUser()
        } catch {
            throw FirebaseError.unknown(error)
        }
    }
    
    
    func signout() throws {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            throw FirebaseError.unknown(error)
        }
    }
    
    func delete() async throws {
        guard let user = userSession else {
            throw FirebaseError.invalidUser
        }
        
        try await user.delete()
    }

    
    func resetPassword(withEmail email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch let error as NSError {
            switch AuthErrorCode.Code(rawValue: error.code) {
            case .invalidEmail:
                throw FirebaseError.invalidCredentials
            case .userNotFound:
                throw FirebaseError.invalidUser
            case .networkError:
                throw FirebaseError.serverError
            default:
                throw FirebaseError.unknown(error)
            }
        }
    }
    
    func reauthenticateUser(email: String, password: String) async throws {
        guard let userSession else { throw FirebaseError.invalidUser }
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        do {
            try await userSession.reauthenticate(with: credential)
        } catch let error as NSError {
            switch AuthErrorCode.Code(rawValue: error.code) {
            case .invalidEmail:
                throw FirebaseError.invalidCredentials
            case .wrongPassword:
                throw FirebaseError.invalidCredentials
            case .networkError:
                throw FirebaseError.serverError
            default:
                throw FirebaseError.unknown(error)
            }
        }
    }
    
    func updatePassword(email: String, oldPassword: String, newPassword: String) async throws {
        guard let userSession else { throw FirebaseError.invalidUser }
        do {
            try await reauthenticateUser(email: email, password: oldPassword)
            try await userSession.updatePassword(to: newPassword)
        } catch let error as NSError {
            switch AuthErrorCode.Code(rawValue: error.code) {
            case .invalidEmail:
                throw FirebaseError.invalidCredentials
            case .wrongPassword:
                throw FirebaseError.invalidCredentials
            case .networkError:
                throw FirebaseError.serverError
            default:
                throw FirebaseError.unknown(error)
            }
        }
    }
    
    func fetchUser() async throws {
        guard let uid = userSession?.uid else { throw FirebaseError.invalidUser }
        guard let snapshot = try? await db.collection("users").document(uid).getDocument() else { throw FirebaseError.invalidData }
        let user = try? snapshot.data(as: User.self)
        self.currentUser = user
    }
    
    
    func updateUserProfileImage(withURL url: String) async throws {
        guard let uid = userSession?.uid else { throw FirebaseError.invalidUser }
        let updateData: [String: String] = ["profileImageURL": url]
        try await db.collection("users").document(uid).updateData(updateData)
        self.currentUser?.profileImageURL = url
    }
    
    func uploadProfileImage(uiImage: UIImage) async throws -> String? {
        guard let imageData = uiImage.jpegData(compressionQuality: 0.25) else { return nil }
        let storageRef = Storage.storage().reference(withPath: "/profile_image/\(UUID().uuidString)")
        
        do {
            _ = try await storageRef.putDataAsync(imageData)
            let url = try await storageRef.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: Could not upload profile image \(error)")
            return nil
        }
    }
    
    func saveTrip(tripId: String, tripName name: String, coordinates: CLLocationCoordinate2D, startDate: String, endDate: String, plans: [Plan]) async throws {
        guard let uid = userSession?.uid else { throw FirebaseError.invalidUser }
        let tripData: [String: Any] = [
            "id": tripId,
            "tripName": name,
            "latitude": coordinates.latitude,
            "longitude": coordinates.longitude,
            "startDate": startDate,
            "endDate": endDate,
            "plans": plans
        ]
        
        try await db.collection("users").document(uid).collection("trips").addDocument(data: tripData)
    }
    
    func loadTrips() async throws -> [Trip] {
        guard let uid = userSession?.uid else { throw FirebaseError.invalidUser }
        guard let snapshot = try? await db.collection("users").document(uid).collection("trips").getDocuments() else { throw FirebaseError.invalidData }
        
        let trips = snapshot.documents.compactMap { document -> Trip? in
            return try? document.data(as: Trip.self)
        }
        
        return trips
    }
    
    func deleteTrip(withId id: String) async throws {
        guard let uid = userSession?.uid else { throw FirebaseError.invalidUser }
        do {
            try await db.collection("users").document(uid).collection("trips").document(id).delete()
        } catch {
            throw FirebaseError.unknown(error)
        }
    }
    
    func updatePlans(plan: Plan, tripId: String) async throws {
        guard let uid = userSession?.uid else { throw FirebaseError.invalidUser }
        
        let planData: [String: Any] = [
            "id": plan.id,
            "type": plan.type,
            "name": plan.name,
            "startDate": plan.startDate,
            "endDate": plan.endDate ?? plan.startDate,
            "address": plan.address ?? "",
            "email": plan.email ?? "",
            "website": plan.website ?? "",
            "phone": plan.phone ?? "",
            "flightNumber": plan.flightNumber ?? "" ,
            "route": plan.route ?? "",
            "departureCity": plan.departureCity ?? "",
            "arrivalCity": plan.arrivalCity ?? "",
            "location": [
                "latitude": plan.location?.latitude ?? 0,
                "longitude": plan.location?.longitude ?? 0
            ],
            "departureLocation": [
                "latitude": plan.departureLocation?.latitude ?? 0,
                "longitude": plan.departureLocation?.longitude ?? 0
            ],
            "arrivalLocation": [
                "latitude": plan.arrivalLocation?.latitude ?? 0,
                "longitude": plan.arrivalLocation?.longitude ?? 0
            ]
        ]
        
        let tripRef = db.collection("users").document(uid).collection("trips").document(tripId)
        let snapshot = try await tripRef.getDocument()
        
        guard var existingPlans = snapshot.data()?["plans"] as? [[String: Any]] else { throw FirebaseError.invalidData }
        
        existingPlans.append(planData)
        let newPlans: [String: Any] = ["plans": existingPlans]
        try await tripRef.updateData(newPlans)
        
        print("DEBUG: Plans updated succesfully.")
    }
    
    func deletePlan(from tripId: String, planId: String) async throws {
        guard let uid = userSession?.uid else { throw FirebaseError.invalidUser }
        let tripRef = db.collection("users").document(uid).collection("trips").document(tripId)
        
        let snapshot = try await tripRef.getDocument()
        
        guard var trip = try? snapshot.data(as: Trip.self) else { throw FirebaseError.invalidData }
        
        trip.plans.removeAll { $0.id == planId }
        try tripRef.setData(from: trip)
    }
    
    func refreshTrip(id: String) async throws -> Trip {
        guard let uid = userSession?.uid else { throw FirebaseError.invalidUser }
        let tripRef = db.collection("users").document(uid).collection("trips").document(id)
        
        let snapshot = try await tripRef.getDocument()
        
        guard let trip = try? snapshot.data(as: Trip.self) else { throw FirebaseError.invalidData }
        return trip
    }
    
    func fetchTripId(by tripId: String) async throws -> String? {
        guard let uid = userSession?.uid else { throw FirebaseError.invalidUser }
        
        let snapshot = try await db.collection("users").document(uid).collection("trips").whereField("id", isEqualTo: tripId).getDocuments()
        
        guard let document = snapshot.documents.first else { throw FirebaseError.invalidData }
        
        return document.documentID
    }
}
