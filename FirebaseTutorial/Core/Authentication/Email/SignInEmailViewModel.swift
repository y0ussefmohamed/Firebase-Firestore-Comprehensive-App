//
//  SignInEmailViewModel.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 10/02/2026.
//

import Foundation
import Combine

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    let userManager = UserManager.shared
    let authManager = AuthenticationManager.shared
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print ("Please fill in all fields")
            return
        }
        
        let authDataResult = try await authManager.createUser(email: email, password: password)
        let dbUser = DBUser(authDataUser: authDataResult)
        
        try userManager.createNewUser(from: dbUser)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print ("Please fill in all fields")
            return
        }
        
        try await authManager.signIn(email: email, password: password)
    }
}
