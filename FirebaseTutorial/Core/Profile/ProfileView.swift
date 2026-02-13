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
        viewModel.user?.preferences?.contains(option) == true
    }
    
    var body: some View {
        List {
            if let user = viewModel.user {
                // 1. SLIM LUXURY PREMIUM CARD
                Section {
                    premiumCard(user: user)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .padding(.bottom, 10)
                
                // 2. ACCOUNT INFORMATION
                Section {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Account Details")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                            .padding(.bottom, 8)
                            .padding(.leading, 4)
                        
                        VStack(spacing: 0) {
                            if let email = user.email, !email.isEmpty {
                                infoRow(title: "Email", value: email, icon: "envelope.fill", color: .blue)
                                Divider().padding(.leading, 44)
                            }
                            
                            let isAnonymous = user.isAnonymous ?? false
                            infoRow(
                                title: "Account Type",
                                value: isAnonymous ? "Guest Account" : "Registered User",
                                icon: isAnonymous ? "person.badge.key.fill" : "person.text.rectangle.fill",
                                color: isAnonymous ? .orange : .green
                            )
                            
                            Divider().padding(.leading, 44)
                            
                            infoRow(title: "User ID", value: user.userId, icon: "number", color: .gray)
                        }
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
                // 3. GENRE PREFERENCES
                Section {
                    genresDisplay(user: user)
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
                // 4. FAVORITE MOVIE
                Section {
                    movieDisplay(user: user)
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 20, trailing: 20))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
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
                        .font(.subheadline)
                }
            }
        }
    }
}

// MARK: - Components
extension ProfileView {
    
    @ViewBuilder
    private func premiumCard(user: DBUser) -> some View {
        let isPremium = user.isPremium ?? false
        
        Button {
            viewModel.togglePremiumStatus()
        } label: {
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        isPremium ?
                        LinearGradient(colors: [Color(white: 0.08), Color(white: 0.15)], startPoint: .topLeading, endPoint: .bottomTrailing) :
                        LinearGradient(colors: [Color(.systemGray6)], startPoint: .top, endPoint: .bottom)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(isPremium ? Color.gold.opacity(0.4) : Color.clear, lineWidth: 0.5)
                    )
                
                HStack(spacing: 12) {
                    // Shrunken Icon
                    ZStack {
                        Circle()
                            .fill(isPremium ? Color.gold.opacity(0.15) : Color.gray.opacity(0.1))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: isPremium ? "crown.fill" : "star.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(isPremium ? Color.gold : .secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(isPremium ? "Premium Member" : "Standard Plan")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(isPremium ? .white : .primary)
                        
                        Text(isPremium ? "Exclusive perks active" : "Get more features")
                            .font(.caption2)
                            .foregroundColor(isPremium ? Color.gold.opacity(0.8) : .secondary)
                    }
                    
                    Spacer()
                    
                    // Slimmer Action Label
                    Text(isPremium ? "MANAGE" : "UPGRADE")
                        .font(.system(size: 10, weight: .black))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(isPremium ? Color.gold : Color.blue)
                        .foregroundColor(isPremium ? .black : .white)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14) // Reduced vertical padding
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .shadow(color: isPremium ? Color.black.opacity(0.3) : Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func infoRow(title: String, value: String, icon: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .frame(width: 28, height: 28)
                .background(color.opacity(0.1))
                .foregroundColor(color)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                Text(value)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .lineLimit(1)
            }
            
            Spacer()
            
            if title == "User ID" {
                Button {
                    UIPasteboard.general.string = value
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                } label: {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                        .padding(6)
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }
    
    private func genresDisplay(user: DBUser) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Preferences")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .padding(.leading, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(preferenceOptions, id: \.self) { option in
                        let isSelected = preferenceIsSelected(option)
                        Button {
                            isSelected ? viewModel.removeUserPreferences(option) : viewModel.addUserPreferences(option)
                        } label: {
                            Text(option)
                                .font(.system(size: 12, weight: .medium))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(isSelected ? Color.green : Color(.secondarySystemBackground))
                                .foregroundColor(isSelected ? .white : .primary)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                    }
                }
            }
        }
    }

    
    private func movieDisplay(user: DBUser) -> some View {
        Button {
            user.favoriteMovie == nil ? viewModel.addFavoriteMovie() : viewModel.removeFavoriteMovie()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "popcorn.fill")
                    .font(.subheadline)
                    .foregroundStyle(.orange.gradient)
                    .frame(width: 36, height: 36)
                    .background(Color.orange.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("Favorite Movie")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    
                    if let title = user.favoriteMovie?.title {
                        Text(title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    } else {
                        Text("Add a Movie")
                            .font(.subheadline)
                            .foregroundColor(.secondary.opacity(0.5))
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.secondary.opacity(0.4))
            }
            .padding(12)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Extensions
extension Color {
    static let gold = Color(red: 212/255, green: 175/255, blue: 55/255)
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
    }
}
