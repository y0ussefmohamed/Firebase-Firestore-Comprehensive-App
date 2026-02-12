//
//  FirebaseTutorialApp.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 08/02/2026.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct FirebaseTutorialApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                RootView()
                    .environmentObject(viewModel)
            }
        }
    }
}


