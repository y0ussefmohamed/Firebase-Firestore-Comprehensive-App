# Firebase Firestore Comprehensive App

A robust, feature-rich iOS application built with **SwiftUI** and **Firebase**, demonstrating advanced integration of Firestore, Authentication, and scalable MVVM architecture.

## Features

- **Multi-Method Authentication**:
  - Secure Email & Password sign-up/log-in.
  - Seamless Google Sign-In integration.
  - Anonymous (Guest) sign-in with account linking support.
- **Dynamic Firestore Integration**:
  - Real-time data fetching and synchronization.
  - Advanced querying with filtering by category, price range, and sort options.
  - **Cursor-based pagination** for efficient product loading.
- **Per-User Favorites System**:
  - Favorites stored in each user's Firestore document — fully account-scoped.
  - Favorites persist across sign-out/sign-in sessions without data loss.
  - Dedicated Favorites tab with swipe-to-remove support.
- **Clean Logout State Management**:
  - Sort option, category filter, and price range are fully reset on logout or account deletion.
  - Each user session starts with a fresh, default product browsing experience.
  - No stale filter state leaks between accounts.
- **Sophisticated Profile Management**:
  - Premium membership card with toggle.
  - Genre/preference management with array field operations.
  - Favorite movie selection.
  - User account details with copy-to-clipboard.
- **Product Experience**:
  - Interactive product catalog with paginated browsing.
  - Heart toggle on product cards for quick favoriting.
  - Multi-filter support (price sort, category, price range — combinable).
- **Modern Architecture**:
  - Clean **MVVM (Model-View-ViewModel)** design pattern.
  - Shared `@EnvironmentObject` for consistent state across tabs.
  - Safe re-login: returning users' data is preserved (no document overwrites).
  - Dependency injection and singleton managers.
  - Scalable folder structure for growing projects.

## Tech Stack

- **Language**: Swift 5+
- **Framework**: SwiftUI
- **Backend**: Firebase
  - Firebase Authentication
  - Cloud Firestore
- **Libraries**: SDWebImageSwiftUI (async image loading)
- **Tools**: Xcode, Google Sign-In SDK

## Project Structure

```text
FirebaseTutorial/
├── App/                          # Application Entry Point
├── Firebase Auth/                # Auth & Google Sign-In Helpers
├── Core/
│   ├── Authentication/           # Sign-In Views & ViewModels (Email, Google, Anonymous)
│   ├── Products/
│   │   ├── Favorites/            # FavoriteProductsView, FavoriteRow
│   │   ├── Sub Views/            # ProductCardView
│   │   ├── ProductsView.swift    # Main catalog with filters & pagination
│   │   └── ProductsViewModel.swift
│   ├── Profile/                  # User profile with premium card & preferences
│   ├── Settings/                 # Account management (logout, delete, link accounts)
│   ├── Root/                     # Root navigation controller
│   └── Tab Bar/                  # TabBarView (Products, Favorites, Profile)
├── Extensions/                   # Firestore Query helpers
├── Firestore/                    # ProductsManager & UserManager
├── Utilities/                    # Helpers and mock data
└── Assets.xcassets               # Images and brand assets
```

## Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/y0ussefmohamed/Firebase-Firestore-Comprehensive-App.git
   ```
2. Open `FirebaseTutorial.xcodeproj` in Xcode.
3. Add your `GoogleService-Info.plist` to the base directory.
4. Enable **Authentication** (Email/Google/Anonymous) and **Firestore** in your Firebase Console.
5. Build and run!

---

Developed by **Youssef Mohamed**
