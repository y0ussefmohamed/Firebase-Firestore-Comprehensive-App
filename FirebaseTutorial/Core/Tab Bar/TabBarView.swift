//
//  TabBarView.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 12/02/2026.
//

import SwiftUI

// MARK: - New Developer Menu
struct DeveloperToolsView: View {
    var body: some View {
        List {
            Section(header: Text("Firebase Testing")) {
                NavigationLink(destination: AnalyticsView()) {
                    Label("Analytics Tracker", systemImage: "chart.bar.fill")
                        .foregroundColor(.blue)
                }
                
                NavigationLink(destination: PerformanceView()) {
                    Label("Performance Tracker", systemImage: "speedometer")
                        .foregroundColor(.green)
                }
                
                NavigationLink(destination: CrashlyticsView()) {
                    Label("Crashlytics Tester", systemImage: "ladybug.fill")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("Developer Tools")
    }
}

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
            
            // MARK: - New Tab
            NavigationStack {
                DeveloperToolsView()
            }
            .tabItem {
                Label("Developer", systemImage: "hammer.fill")
            }
        }
    }
}

#Preview {
    TabBarView(showSignInView: .constant(false))
}
