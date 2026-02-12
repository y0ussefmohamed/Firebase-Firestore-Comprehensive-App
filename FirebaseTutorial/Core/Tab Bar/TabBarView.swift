//
//  TabBarView.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 12/02/2026.
//

import SwiftUI

struct TabBarView: View {
    @Binding var showSignInView: Bool
    var body: some View {
        TabView {
            NavigationStack {
                ProductsView()
            }
            .tabItem {
                Label("Products", systemImage: "cart")
            }
            
            NavigationStack {
                FavoriteProductsView()
            }
            .tabItem {
                Label("Favorites", systemImage: "star")
            }
            
            NavigationStack {
                ProfileView(showSignInView: $showSignInView)
            }
            .tabItem {
                Label("Profile", systemImage: "person.circle")
            }
        }
    }
}

#Preview {
    TabBarView(showSignInView: .constant(false))
}
