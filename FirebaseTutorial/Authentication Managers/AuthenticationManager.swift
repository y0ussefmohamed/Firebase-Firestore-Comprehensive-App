//
//  AuthenticationManager.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 08/02/2026.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    let isAnonymous: Bool
    
    /// Firebase User Type Model
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.isAnonymous = user.isAnonymous
    }
}

enum AuthProviderOption: String {
    case email  = "password"
    case google = "google.com"
    case apple  = "apple.com"
}


// MARK: - Basic Functions
final class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    private init() {}
    
    /// non async funcs operate locally in non-concurrent manner
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func getProviders() throws -> [AuthProviderOption] {
        guard let providedData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        var providers: [AuthProviderOption] = []
        for provider in providedData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider Option not found: \(provider.providerID)")
            }
        }
        
        return providers
    }
    
    func delete() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.unknown)
        }
        
        try await user.delete()
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
}

// MARK: - Sign In Email
extension AuthenticationManager {
    @discardableResult /// as if you make let _ = createUser()
    func createUser(email: String, password: String) async throws -> AuthDataResultModel { /// async funcs reaches the server
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let result = AuthDataResultModel(user: authDataResult.user)
        
        return result
    }
    
    @discardableResult
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        let result = AuthDataResultModel(user: authDataResult.user)
        
        return result
    }
    
    func updateEmail(newEmail: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.updateEmail(to: newEmail)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updatePassword(newPassword: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.updatePassword(to: newPassword)
    }
}


// MARK: - Sign In SSO
extension AuthenticationManager {
    @discardableResult
    private func signIn(withCredential credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        let result = AuthDataResultModel(user: authDataResult.user)
        
        return result
    }
    
    @discardableResult
    func signInGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(withCredential: credential)
    }
}


// MARK: - Anonymous Operations
extension AuthenticationManager {
    @discardableResult
    func signInAnonymously() async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signInAnonymously()
        let result = AuthDataResultModel(user: authDataResult.user)
        
        return result
    }
    
    @discardableResult /// Get credentials and link them with the user
    private func linkCredential(_ credential: AuthCredential) async throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.unknown)
        }
        
        let authDataResult = try await user.link(with: credential)
        let result = AuthDataResultModel(user: authDataResult.user)
        
        return result
    }
    
    @discardableResult
    func linkEmail(email: String, password: String) async throws -> AuthDataResultModel {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        return try await linkCredential(credential)
    }
    
    @discardableResult
    func linkGoogleAccount(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await linkCredential(credential)
    }
}
