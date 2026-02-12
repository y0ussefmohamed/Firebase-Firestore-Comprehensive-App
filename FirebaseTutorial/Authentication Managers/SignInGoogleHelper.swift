//
//  SignInGoogleHelper.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 09/02/2026.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift


struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
}

/// Opens the google view controller and gets the email and tokens
final class SignInGoogleHelper{
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.badServerResponse)
        }
        
        let gidResult =  try await
        GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken: String = gidResult.user.idToken?.tokenString else { throw URLError(.badServerResponse) }
        let accessToken: String = gidResult.user.accessToken.tokenString
        
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
        
        return tokens
    }
}
