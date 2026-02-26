//
//  ProfileViewModel.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 10/02/2026.
//


import Foundation
import Combine


@MainActor
final class ProfileViewModel: ObservableObject
{
    @Published private(set) var user: DBUser? = nil
    
    let userManager = UserManager.shared
    let authManager = AuthenticationManager.shared
    
    func loadCurrentUser() async throws {
        let authDataResult = try? authManager.getAuthenticatedUser()
        
        if let authUser = authDataResult {
            self.user = try await userManager.getUser(userID: authUser.uid)
        }
    }
    
    func togglePremiumStatus() {
        guard let user else { return }
        let isPremium = user.isPremium ?? false
        
        Task { /// Use `Task` and don't use async await becase this function will be used in a Button
            do {
                try await userManager.updateUserPremiumStatus(isPremium: !isPremium, for: user)
                self.user = try await userManager.getUser(userID: user.userId)
            } catch {
                print(error)
            }
        }
    }
    
    func addUserPreferences(_ preferredText: String) {
        guard let user else { return }
        
        Task {
            do {
                try await userManager.addUserPreferences(preferences: preferredText, for: user)
                self.user = try await userManager.getUser(userID: user.userId)
            } catch {
                print(error)
            }
        }
    }
    
    func removeUserPreferences(_ preferredText: String) {
        guard let user else { return }
        
        Task {
            do {
                try await userManager.removeUserPreferences(preferences: preferredText, for: user)
                self.user = try await userManager.getUser(userID: user.userId)
            } catch {
                print(error)
            }
        }
    }
    
    func addFavoriteMovie() {
        guard let user else { return }
        let movie = Movie(id: "1", title: "Avatar", isPopular: true)
        
        Task {
            do {
                try await userManager.addFavoriteMovie(movie: movie, for: user)
                self.user = try await userManager.getUser(userID: user.userId)
            } catch {
                print(error)
            }
        }
    }
    
    func removeFavoriteMovie() {
        guard let user else { return }
        let movie = Movie(id: "1", title: "Avatar", isPopular: true)
        
        Task {
            do {
                try await userManager.removeFavoriteMovie(movie: movie, for: user)
                self.user = try await userManager.getUser(userID: user.userId)
            } catch {
                print(error)
            }
        }
    }
}
