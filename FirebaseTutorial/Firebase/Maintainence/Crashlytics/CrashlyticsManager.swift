//
//  CrashlyticsView.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 28/02/2026.
//

import SwiftUI
import Foundation
import FirebaseCrashlytics

final class CrashlyticsManager
{
    static let shared = CrashlyticsManager()
    private init() { }
    
    func setUserId(userId: String) {
        Crashlytics.crashlytics().setUserID(userId)
    }
    
    func setIsPremiumValue(isPremium: Bool) {
        Crashlytics.crashlytics().setCustomValue(isPremium.description.lowercased(), forKey: "user_is_premium")
    }
    
    func addLog(message: String) {
        Crashlytics.crashlytics().log(message)
    }
    
    func sendNonFatalError() {
        Crashlytics.crashlytics().record(error: URLError(.badURL))
    }
}

struct CrashlyticsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Header Description
                    Text("Trigger different types of errors to test Firebase Crashlytics. Warning: The fatal actions will immediately terminate the app.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // MARK: - Non-Fatal Error Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text("Logged Exceptions")
                                .font(.headline)
                        }
                        
                        Text("Logs a breadcrumb `button_1_clicked`, then simulates a handled error without crashing the app.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            CrashlyticsManager.shared.addLog(message: "button_1_clicked")

                            let myString: String? = nil
                            
                            guard let myString else {
                                CrashlyticsManager.shared.sendNonFatalError()
                                return
                            }
                            
                            let _ = myString
                        }) {
                            Text("Trigger Non-Fatal Error")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange.opacity(0.15))
                                .foregroundColor(.orange)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // MARK: - Fatal Crashes Card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "xmark.octagon.fill")
                                .foregroundColor(.red)
                            Text("Fatal Crashes")
                                .font(.headline)
                        }
                        
                        Text("These buttons will terminate the app immediately. Crashlytics will upload the report on the NEXT app launch.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        // Crash 1: fatalError
                        VStack(alignment: .leading, spacing: 6) {
                            Text("1. Explicit Fatal Error")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Button(action: {
                                CrashlyticsManager.shared.addLog(message: "button_2_clicked")
                                fatalError("This was a fatal crash.")
                            }) {
                                CrashButtonLabel(title: "Execute fatalError()")
                            }
                        }
                        
                        // Crash 2 & 3: Out of Bounds
                        VStack(alignment: .leading, spacing: 6) {
                            Text("2. Index Out of Range")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            HStack(spacing: 12) {
                                Button(action: {
                                    CrashlyticsManager.shared.addLog(message: "button_3_clicked")
                                    let array: [String] = []
                                    let _ = array[0]
                                }) {
                                    CrashButtonLabel(title: "Array[0]")
                                }
                                
                                Button(action: {
                                    CrashlyticsManager.shared.addLog(message: "button_3_clicked")
                                    let array: [String] = []
                                    let _ = array[1]
                                }) {
                                    CrashButtonLabel(title: "Array[1]")
                                }
                            }
                        }
                        
                        // Crash 4: Force Unwrap Nil
                        VStack(alignment: .leading, spacing: 6) {
                            Text("3. Force Unwrapping Nil")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Button(action: {
                                CrashlyticsManager.shared.addLog(message: "button_5_clicked")
                                
                                let nilString: String? = nil
                                let _ = nilString!
                            }) {
                                CrashButtonLabel(title: "Force Unwrap (!)")
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // MARK: - Crash Context Info Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.blue)
                            Text("Crash Context (Auto-logged)")
                                .font(.headline)
                        }
                        
                        Text("This data is automatically attached to any crash that occurs on this screen to help with debugging.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 4)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("User ID set to: `ABC123`", systemImage: "person.text.rectangle")
                            Label("Premium Status set to: `true`", systemImage: "star.fill")
                            Label("Log: 'Crash view appeared...'", systemImage: "text.alignleft")
                        }
                        .font(.caption)
                        .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                }
                .padding(.vertical)
            }
            .navigationTitle("Crashlytics Tester")
            .navigationBarTitleDisplayMode(.inline)
            
            // MARK: - Actual Crashlytics Context Setup
            .onAppear {
                CrashlyticsManager.shared.setUserId(userId: "ABC123")
                CrashlyticsManager.shared.setIsPremiumValue(isPremium: true)
                CrashlyticsManager.shared.addLog(message: "Crash view appeared on user's screen.")
            }
        }
    }
}

// A small helper to keep the fatal crash buttons looking consistent
struct CrashButtonLabel: View {
    let title: String
    var body: some View {
        Text(title)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

struct CrashlyticsView_Previews: PreviewProvider {
    static var previews: some View {
        CrashlyticsView()
    }
}
