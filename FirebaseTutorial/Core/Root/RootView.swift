//
//  RootView.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 08/02/2026.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView: Bool = false
    
    var body: some View {
        TabBarView(showSignInView: $showSignInView)
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            
            self.showSignInView = authUser != nil ? false : true
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    RootView()
}
