//
//  AutheticationView.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 08/02/2026.
//

import SwiftUI
import Combine
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            anonymousSignInButton
            
            emailSignInButton

            googleSignInButton

            appleSignInButton
            
            Spacer()
        }
        .navigationTitle("Sign In")
    }
}


extension AuthenticationView {
    var anonymousSignInButton: some View {
        Button {
            Task {
                do {
                    try await viewModel.signInAnonymously()
                    showSignInView = false
                } catch {
                    print(error)
                }
            }
        } label: {
            Text("Sign In Anonymously")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(Color.orange)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding(.top,30)
        .padding(.horizontal,20)
    }
    
    
    var emailSignInButton: some View {
        NavigationLink {
            SignInEmailView(showSignInView: $showSignInView)
        } label: {
            Text("Sign In With Email")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding(20)
    }
    
    var googleSignInButton: some View {
        GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
            Task {
                do {
                    try await viewModel.signInGoogle()
                    showSignInView = false
                } catch {
                    print(error)
                }
            }
        }
        .padding(.horizontal, 25)
    }
    
    var appleSignInButton: some View {
        SignInWithAppleButton { request  in
            
        } onCompletion: { result in
            
        }
        .frame(height: 55)
        .padding(.horizontal, 25)
        .padding(.top, 20)
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(showSignInView: .constant(false))
    }
}
