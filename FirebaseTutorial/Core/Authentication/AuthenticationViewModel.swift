//
//  AuthenticationViewModel.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 10/02/2026.
//

import Foundation
import Combine
import FirebaseAuth
import Firebase

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    @Published var authUser: AuthDataResultModel? = nil
    
    let userManager = UserManager.shared
    let authManager = AuthenticationManager.shared
    let googleHelper = SignInGoogleHelper()
    
    func loadAuthUser() {
        self.authUser = try? authManager.getAuthenticatedUser()
    }
    
    func signInGoogle() async throws {
        let tokens = try await googleHelper.signIn()
        let authDataResult = try await authManager.signInGoogle(tokens: tokens)
        let dbUser = DBUser(authDataUser: authDataResult)
        
        try userManager.createNewUser(from: dbUser)
    }
    
    func signInAnonymously() async throws {
        let authDataResult = try await authManager.signInAnonymously()
        let dbUser = DBUser(authDataUser: authDataResult)
        
        try userManager.createNewUser(from: dbUser)
    }
}
