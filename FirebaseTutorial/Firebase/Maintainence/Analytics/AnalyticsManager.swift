//
//  AnalyticsManager.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 01/03/2026.
//

import SwiftUI
import FirebaseAnalytics

final class AnalyticsManager {
    
    static let shared = AnalyticsManager()
    private init() { }
    
    func setUserId(userId: String) {
        Analytics.setUserID(userId)
    }
    
    func setUserProperty(value: String?, property: String) {
        Analytics.setUserProperty(value, forName: property)
    }
    
    func logEvent(name: String, params: [String:Any]? = nil) {
        Analytics.logEvent(name, parameters: params)
    }
}

struct AnalyticsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    Text("Interact with the buttons below to trigger Firebase Analytics events. Lifecycle events are tracked automatically.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // MARK: - Event 1: Basic Click
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "hand.tap.fill")
                                .foregroundColor(.blue)
                            Text("Basic Event")
                                .font(.headline)
                        }
                        
                        Text("Logs: `AnalyticsView_ButtonClick`\nNo additional parameters are sent.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            AnalyticsManager.shared.logEvent(name: "AnalyticsView_ButtonClick")
                        }) {
                            Text("Trigger Basic Event")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.15))
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // MARK: - Event 2: Parameter Click
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "list.bullet.rectangle.fill")
                                .foregroundColor(.purple)
                            Text("Parameterized Event")
                                .font(.headline)
                        }
                        
                        Text("Logs: `AnalyticsView_SecondaryButtonClick`\nParams: `[screen_title: Hello, world!]`")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            AnalyticsManager.shared.logEvent(name: "AnalyticsView_SecondaryButtonClick", params: [
                                "screen_title" : "Hello, world!"
                            ])
                        }) {
                            Text("Trigger Parameter Event")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple.opacity(0.15))
                                .foregroundColor(.purple)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // MARK: - Lifecycle Info Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .foregroundColor(.green)
                            Text("Lifecycle Events (Auto-logged)")
                                .font(.headline)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("onAppear: `AnalyticsView_Appear`", systemImage: "eye.fill")
                            Label("onDisappear: `AnalyticsView_Disappear`", systemImage: "eye.slash.fill")
                            Label("User ID set to: `ABC123`", systemImage: "person.text.rectangle")
                            Label("Property `user_is_premium` set to: `true`", systemImage: "star.fill")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                }
                .padding(.vertical)
            }
            .navigationTitle("Analytics Tracker")
            .navigationBarTitleDisplayMode(.inline)
            // MARK: - Actual Analytics Calls
            .analyticsScreen(name: "AnalyticsView")
            .onAppear {
                AnalyticsManager.shared.logEvent(name: "AnalyticsView_Appear")
            }
            .onDisappear {
                AnalyticsManager.shared.logEvent(name: "AnalyticsView_Disppear")
                
                AnalyticsManager.shared.setUserId(userId: "ABC123")
                AnalyticsManager.shared.setUserProperty(value: true.description, property: "user_is_premium")
            }
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
