import SwiftUI
import GoogleSignInSwift

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        ZStack {
            // Background color for a modern feel
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                headerView
                
                VStack(spacing: 12) {
                    anonymousSignInButton
                    emailSignInButton
                }
                
                orDivider
                
                VStack(spacing: 12) {
                    googleSignInButton
                    appleSignInButton
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Subviews
extension AuthenticationView {
    
    private var headerView: some View {
        VStack(spacing: 12) {
            Image(systemName: "lock")
                .font(.system(size: 60))
                .foregroundStyle(.blue.gradient)
                .padding(.bottom, 10)
            
            Text("Welcome")
                .font(.largeTitle.bold())
            
            Text("Select a method to continue your journey.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 40)
    }
    
    private var orDivider: some View {
        HStack {
            Rectangle().frame(height: 1).opacity(0.1)
            Text("OR")
                .font(.caption2.bold())
                .foregroundStyle(.secondary)
            Rectangle().frame(height: 1).opacity(0.1)
        }
        .padding(.vertical, 20)
    }
    
    var emailSignInButton: some View {
        NavigationLink {
            SignInEmailView(showSignInView: $showSignInView)
        } label: {
            Label("Sign In With Email", systemImage: "envelope.fill")
                .modifier(PrimaryButtonStyle(backgroundColor: .blue))
        }
    }

    var anonymousSignInButton: some View {
        Button {
            Task {
                do {
                    try await viewModel.signInAnonymously()
                    showSignInView = false
                } catch { print(error) }
            }
        } label: {
            Label("Continue as Guest", systemImage: "person.fill.questionmark")
                .modifier(PrimaryButtonStyle(backgroundColor: .orange))
        }
    }
    
    var googleSignInButton: some View {
        Button {
            Task {
                do {
                    try await viewModel.signInGoogle()
                    showSignInView = false
                } catch { print(error) }
            }
        } label: {
            HStack(spacing: 12) {
                Image("google_logo") // Standard multi-color G
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text("Sign in with Google")
                    .font(.headline)
            }
            .modifier(PrimaryButtonStyle(backgroundColor: .white, foregroundColor: .black))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }
    
    var appleSignInButton: some View {
        Button {
            // Apple Sign In Logic
        } label: {
            Label("Sign In With Apple", systemImage: "apple.logo")
                .modifier(PrimaryButtonStyle(backgroundColor: .black))
        }
    }
}

// MARK: - Reusable Modifiers
struct PrimaryButtonStyle: ViewModifier {
    var backgroundColor: Color
    var foregroundColor: Color = .white
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundStyle(foregroundColor)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(showSignInView: .constant(false))
    }
}
