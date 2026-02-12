//
//  ProfileView.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 10/02/2026.
//

import SwiftUI


struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    let preferenceOptions: [String] = ["Sport", "Movie", "Book"]
    private func preferenceIsSelected(_ option: String) -> Bool {
        viewModel.user?
            .preferences?
            .contains(option) == true
    }
    
    var body: some View {
        List {
            if let user = viewModel.user {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Account Information")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .padding(.leading, 4)

                    VStack(spacing: 0) {
                        // Email Row (if exists)
                        if let email = user.email, !email.isEmpty {
                            infoRow(title: "Email", value: email, icon: "envelope.fill", color: .blue)
                            Divider().padding(.leading, 44)
                        }
                        
                        // Account Type / Anonymous Row
                        let isAnonymous = user.isAnonymous ?? false
                        infoRow(
                            title: "Account Type",
                            value: isAnonymous ? "Guest Account" : "Registered User",
                            icon: isAnonymous ? "person.badge.key.fill" : "person.text.rectangle.fill",
                            color: isAnonymous ? .orange : .green
                        )
                        
                        Divider().padding(.leading, 44)
                        
                        // User ID Row
                        infoRow(title: "User ID", value: user.userId, icon: "number", color: .gray)
                            .contextMenu {
                                Button {
                                    UIPasteboard.general.string = user.userId
                                } label: {
                                    Label("Copy ID", systemImage: "doc.on.doc")
                                }
                            }
                    }
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }
                .padding(.horizontal)

                
                Button {
                    viewModel.togglePremiumStatus()
                } label: {
                    ZStack {
                        // Background layer: Changes to a gradient if premium
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(
                                user.isPremium ?? false ?
                                LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing) :
                                LinearGradient(colors: [Color(.secondarySystemBackground)], startPoint: .top, endPoint: .bottom)
                            )
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Membership Status")
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                    .foregroundColor((user.isPremium ?? false) ? .white.opacity(0.8) : .secondary)
                                
                                premiumStatusText(user: user)
                            }
                            
                            Spacer()
                            
                            // A "Toggle" indicator
                            Text((user.isPremium ?? false) ? "Manage" : "Upgrade")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background((user.isPremium ?? false) ? .white.opacity(0.2) : .blue)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
                .shadow(color: (user.isPremium ?? false) ? .purple.opacity(0.3) : .clear, radius: 10, x: 0, y: 5)
                
                genresDisplay(user: user)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Account Preferences")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fontWeight(.bold)
                        .padding(.leading, 4)

                    movieDisplay(user: user)
                }
                .padding(.horizontal)
                
                NavigationLink {
                    FavoriteProductsView()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "heart.fill")
                            .font(.footnote)
                            .frame(width: 28, height: 28)
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        
                        Text("Favorite Products in DB")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .navigationTitle("Profile")
        .toolbar {
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
            
        }
    }
}

// MARK: - Helper View
@ViewBuilder
private func infoRow(title: String, value: String, icon: String, color: Color) -> some View {
    HStack(spacing: 12) {
        Image(systemName: icon)
            .font(.footnote)
            .frame(width: 28, height: 28)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)
                .truncationMode(.middle)
        }
        
        Spacer()
        
        // --- ADDED THIS PART ---
        if title == "User ID" {
            Button {
                UIPasteboard.general.string = value
                // Optional: Add a haptic feedback "bump"
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } label: {
                Image(systemName: "doc.on.doc")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(8)
                    .background(Color.secondary.opacity(0.1))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain) // Prevents the whole row from flashing when tapped
        }
    }
    .padding()
}

extension ProfileView {
    func premiumStatusText(user: DBUser) -> some View {
        let isPremium = user.isPremium ?? false
        
        return HStack(spacing: 4) {
            Text(isPremium ? "PREMIUM" : "FREE")
                .font(.caption)
                .fontWeight(.black)
            
            if isPremium {
                Image(systemName: "checkmark.seal.fill")
            }
        }
        .foregroundColor(isPremium ? .yellow : .secondary)
    }
    
    func movieDisplay(user: DBUser) -> some View {
        Button {
            if user.favoriteMovie == nil {
                viewModel.addFavoriteMovie()
            } else {
                viewModel.removeFavoriteMovie()
            }
        } label: {
            HStack {
                Image(systemName: "popcorn.fill")
                    .font(.title2)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.orange)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Favorite Movie")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    if let title = user.favoriteMovie?.title {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.primary)
                    } else {
                        Text("None selected")
                            .font(.headline)
                            .italic()
                            .foregroundColor(.gray.opacity(0.6))
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
        }
    }
    
    func genresDisplay(user: DBUser) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Genre Preferences")
                .font(.headline)
                .padding(.leading, 4)
            
            // Using a Flow-like layout approach
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(preferenceOptions, id: \.self) { option in
                        let isSelected = preferenceIsSelected(option)
                        
                        Button {
                            if isSelected {
                                viewModel.removeUserPreferences(option)
                            } else {
                                viewModel.addUserPreferences(option)
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Text(option)
                                if isSelected {
                                    Image(systemName: "checkmark.circle.fill")
                                        .transition(.scale.combined(with: .opacity))
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(isSelected ? Color.green.opacity(0.2) : Color.secondary.opacity(0.1))
                            )
                            .overlay(
                                Capsule()
                                    .strokeBorder(isSelected ? Color.green : Color.clear, lineWidth: 1)
                            )
                            .foregroundColor(isSelected ? .green : .primary)
                        }
                        .buttonStyle(.plain) // Removes the default button "flash"
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
                    }
                }
                .padding(.horizontal, 4)
            }
            
            // A more subtle way to show the summary
            if let prefs = user.preferences, !prefs.isEmpty {
                HStack {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                    Text("Filtered by: \(prefs.joined(separator: " • "))")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 4)
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
    }
}

extension Color {
    static let gold = Color(red: 212/255, green: 175/255, blue: 55/255)
}
