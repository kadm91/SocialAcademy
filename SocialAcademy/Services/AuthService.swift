//
//  AuthService.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/2/24.
//

import Foundation
import FirebaseAuth

@MainActor
class AuthService: ObservableObject {
    
    @Published var isAuthenticated = false
    @Published var user: User?
    
    private let auth = Auth.auth()
    private var listener: AuthStateDidChangeListenerHandle?
    
    init() {
        listener = auth.addStateDidChangeListener { [weak self] _, user in
            self?.user = user.map(User.init(from:))
        }
    }
    
    // create user
    
    func createAccount(name: String, email: String, password: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
        try await result.user.updateProfile(\.displayName, to: name)
        user?.name = name
    }
    
    // Sign In user
    
    func signIn (email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    // Sign out user
    
    func signOut() throws {
        try auth.signOut()
    }
    
    // set image Url for user profile
    
    func updateProfileImage(to imageFileURL: URL?) async throws {
        guard let user = auth.currentUser else {
            preconditionFailure("Cannont update profile for nil user")
        }
        
        guard let imageFileURL = imageFileURL else {
            try await user.updateProfile(\.photoURL, to: nil)
            if let photoURL = user.photoURL {
                try await StorageFile.atURL(photoURL).delete()
            }
            
            return
        }
        
        async let newPhotoURL = StorageFile
            .with(namespace: "users", identifier: user.uid)
            .putFile(from: imageFileURL)
            .getDownloadURL()
        try await user.updateProfile(\.photoURL, to: newPhotoURL)
        
    }
}

//MARK: - Extension

private extension FirebaseAuth.User {
    func updateProfile<T>(_ keyPath: WritableKeyPath<UserProfileChangeRequest, T>, to newValue: T) async throws {
        var profileChangeRequest = createProfileChangeRequest()
        profileChangeRequest[keyPath: keyPath] = newValue
        try await profileChangeRequest.commitChanges()
    }
}

//MARK: - Convert from firebase user to our User model

private extension User {
    init(from firebaseUser: FirebaseAuth.User) {
        self.id = firebaseUser.uid
        self.name = firebaseUser.displayName ?? ""
        self.imageURL = firebaseUser.photoURL
    }
}
