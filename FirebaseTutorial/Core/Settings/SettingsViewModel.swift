//
//  SettingsViewModel.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 10/02/2026.
//

import Foundation
import Combine

@MainActor
final class SettingsViewModel: ObservableObject
{
    @Published var authUser: AuthDataResultModel? = nil
    @Published var authProviders: [AuthProviderOption] = []
    
    let authManager = AuthenticationManager.shared
    let userManager = UserManager.shared
    
    func loadAuthUser() {
        self.authUser = try? authManager.getAuthenticatedUser()
    }
    
    func loadAuthProviders() {
        if let providers = try? authManager.getProviders() {
            self.authProviders = providers
        }
    }
    
    func logout() throws {
        try authManager.logout()
    }
    
    func resetPassword() async throws {
        let currentUser = try authManager.getAuthenticatedUser()
        
        guard let email = currentUser.email else {
            throw URLError(.badServerResponse)
        }
        
        try await authManager.resetPassword(email: email)
    }
    
    func updatePassword(newPassword: String) async throws {
        try await authManager.updatePassword(newPassword: newPassword)
    }
    
    func updateEmail(newEmail: String) async throws {
        try await authManager.updateEmail(newEmail: newEmail)
    }
    
    func linkEmailAccount() async throws {
        let authDataResult = try await authManager.linkEmail(email: "link@test.com", password: "pass123")
        
        self.authUser = authDataResult
    }
    
    func linkGoogleAccount() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        
        let authDataResult = try await authManager.linkGoogleAccount(tokens: tokens)
        self.authUser = authDataResult
    }
    
    func deleteAccount() async throws {
        try await authManager.delete()
        if let userId = authUser?.uid {
            try await userManager.deleteUser(userID: userId)
        }
    }
    
    func linkAppleAccount() async throws {
        
    }
}
