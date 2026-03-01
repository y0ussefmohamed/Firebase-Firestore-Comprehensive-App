//
//  SignInEmailView.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 08/02/2026.
//

import SwiftUI

struct SignInEmailView: View {
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    @State private var isPasswordVisible: Bool = false
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header section for context
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ready to dive in?")
                        .font(.largeTitle.bold())
                    Text("Enter your credentials to access your account.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 40)
                
                // Input Fields
                VStack(spacing: 16) {
                    customTextField(
                        title: "Email",
                        placeholder: "example@email.com",
                        text: $viewModel.email,
                        systemImage: "envelope"
                    )
                    
                    passwordField
                }
                
                // Error Message (if any)
                if let errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                Button {
                    signInAction()
                } label: {
                    ZStack {
                        Color.clear
                        
                        if viewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Continue")
                                .font(.headline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())   // The "Magic" fix
                }
                .modifier(PrimaryButtonStyle(backgroundColor: .blue))
                .disabled(viewModel.email.isEmpty || viewModel.password.count < 6)
                .opacity(viewModel.email.isEmpty || viewModel.password.count < 6 ? 0.6 : 1.0)
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Components
extension SignInEmailView {
    
    private func customTextField(title: String, placeholder: String, text: Binding<String>, systemImage: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .padding(.leading, 4)
            
            HStack {
                Image(systemName: systemImage)
                    .foregroundStyle(.secondary)
                    .frame(width: 20)
                
                TextField(placeholder, text: text)
                    .textInputAutocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
            }
            .padding()
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
    
    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Password")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .padding(.leading, 4)
            
            HStack {
                Image(systemName: "lock")
                    .foregroundStyle(.secondary)
                    .frame(width: 20)
                
                Group {
                    if isPasswordVisible {
                        TextField("At least 6 characters", text: $viewModel.password)
                    } else {
                        SecureField("At least 6 characters", text: $viewModel.password)
                    }
                }
                
                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
    
    private func signInAction() {
        Task {
            do {
                try await viewModel.signUp()
                
                await MainActor.run {
                    showSignInView = false
                }
            } catch {
                do {
                    try await viewModel.signIn()
                    await MainActor.run {
                        showSignInView = false
                    }
                } catch {
                    await MainActor.run {
                        withAnimation {
                            self.errorMessage = error.localizedDescription
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignInEmailView(showSignInView: .constant(false))
    }
}
