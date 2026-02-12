# Firebase Firestore Comprehensive App

A robust, feature-rich iOS application built with **SwiftUI** and **Firebase**, demonstrating advanced integration of Firestore, Authentication, and scalable MVVM architecture.

## Features

- **Multi-Method Authentication**:
  - Secure Email & Password sign-up/log-in.
  - Seamless Google Sign-In integration.
- **Dynamic Firestore Integration**:
  - Real-time data fetching and synchronization.
  - Advanced querying and data management for products.
- **Sophisticated Profile Management**:
  - Personalized user profiles with real-time updates.
  - Settings management for account customization.
- **Product Experience**:
  - Interactive product catalog.
  - Robust favorites system with persistent state.
- **Modern Architecture**:
  - Clean **MVVM (Model-View-ViewModel)** design pattern.
  - Dependency injection and environment object management.
  - Scalable folder structure for growing projects.

## Tech Stack

- **Language**: Swift 5+
- **Framework**: SwiftUI
- **Backend**: Firebase
  - Firebase Authentication
  - Cloud Firestore
- **Tools**: Xcode, Google Sign-In SDK

## Project Structure

```text
FirebaseTutorial/
├── App/                  # Application Entry Point
├── Authentication/       # Login, Sign-up, and Auth Views
├── Core/                 # Main Feature Modules (Profile, Products, Settings)
├── Firestore/            # Managers for Database Operations
├── Utilities/            # Helpers and Mock Data
└── Assets.xcassets       # Images and Brand Assets
```

## Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/y0ussefmohamed/Firebase-Firestore-Comprehensive-App.git
   ```
2. Open `FirebaseTutorial.xcodeproj` in Xcode.
3. Add your `GoogleService-Info.plist` to the base directory.
4. Enable **Authentication** (Email/Google) and **Firestore** in your Firebase Console.
5. Build and run!

---

Developed by **Youssef Mohamed**
