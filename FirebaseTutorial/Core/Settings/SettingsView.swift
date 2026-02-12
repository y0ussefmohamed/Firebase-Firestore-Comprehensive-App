//
//  SettingsView.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 08/02/2026.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject private var productsViewModel: ProductsViewModel
    @Binding var showSignInView: Bool
    @State private var showDeleteAlert = false
    
    var body: some View {
        List {
            // MARK: - Account Status & Security
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
            
            if (viewModel.authUser?.isAnonymous == true) {
                anonymousSection
            }
            
            // MARK: - Session Management
            Section {
                Button(role: .destructive) {
                    logout()
                } label: {
                    SettingsLabel(title: "Log Out", icon: "arrow.right.circle", color: .red)
                }
                
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    SettingsLabel(title: "Delete Account", icon: "trash.fill", color: .red)
                }
            } header: {
                Text("Session")
            } footer: {
                Text("Deleting your account is permanent and cannot be undone.")
            }
        }
        .onAppear {
            viewModel.loadAuthUser()
            viewModel.loadAuthProviders()
        }
        .navigationTitle("Settings")
        .alert("Delete Account?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) { deleteAccount() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to permanently delete your account?")
        }
    }
}

// MARK: - Subviews
extension SettingsView {
    
    private var emailSection: some View {
        Section(header: Text("Email Security")) {
            Button {
                Task { try? await viewModel.resetPassword() }
            } label: {
                SettingsLabel(title: "Reset Password", icon: "lock.rotation", color: .orange)
            }
            
            Button {
                Task { try? await viewModel.updatePassword(newPassword: "new123") }
            } label: {
                SettingsLabel(title: "Update Password", icon: "key.fill", color: .gray)
            }
            
            Button {
                Task { try? await viewModel.updateEmail(newEmail: "new@example.com") }
            } label: {
                SettingsLabel(title: "Update Email", icon: "envelope.badge.fill", color: .blue)
            }
        }
    }
    
    private var anonymousSection: some View {
        Section(header: Text("Link Accounts"), footer: Text("Link your guest account to a permanent provider to save your data across devices.")) {
            Button {
                Task { try? await viewModel.linkGoogleAccount() }
            } label: {
                SettingsLabel(title: "Link Google", icon: "g.circle.fill", color: .red)
            }
            
            Button {
                Task { try? await viewModel.linkAppleAccount() }
            } label: {
                SettingsLabel(title: "Link Apple", icon: "applelogo", color: .black)
            }
            
            Button {
                Task { try? await viewModel.linkEmailAccount() }
            } label: {
                SettingsLabel(title: "Link Email", icon: "envelope.fill", color: .blue)
            }
        }
    }
}

// MARK: - Actions
extension SettingsView {
    private func logout() {
        do {
            try viewModel.logout()
            productsViewModel.resetUserState()
            showSignInView = true
        } catch {
            print("Error logging out: \(error)")
        }
    }
    
    private func deleteAccount() {
        Task {
            do {
                try await viewModel.deleteAccount()
                productsViewModel.resetUserState()
                showSignInView = true
            } catch {
                print("Error deleting account: \(error)")
            }
        }
    }
}

// MARK: - Helper UI Component
struct SettingsLabel: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
                .padding(6)
                .background(color.opacity(0.1))
                .foregroundColor(color)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundColor(.secondary.opacity(0.5))
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
            .environmentObject(ProductsViewModel())
    }
}
