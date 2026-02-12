//
//  UserManager.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 10/02/2026.
//

import Foundation
import FirebaseFirestore
import FirebaseSharedSwift

struct Movie: Codable {
    let id: String
    let title: String
    let isPopular: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case isPopular = "is_popular"
    }
}

/// this struct is used in storing or getting from the firestore DB only
struct DBUser: Codable {
    let userId: String
    let isAnonymous: Bool?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isPremium: Bool?
    let preferences: [String]?
    let favoriteMovie: Movie?
    let favorite_products: [Product]?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case email
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "is_premium"
        case preferences
        case favoriteMovie = "favorite_movie"
        case favorite_products = "favorite_products"
    }
    
    /*
     /// Sends a new DBUser with all the old values but toggled `isPremium`
     var newPremiumUser: DBUser {
     DBUser(userId: userId, isAnonymous: isAnonymous, email: email, photoUrl: photoUrl, dateCreated: dateCreated, isPremium: !(isPremium ?? false))
     }
     
     /// `mutating` Sends the same DBUser old struct but toggling `isPremium`
     mutating func togglePremium() {
     let currentValue = isPremium ?? false
     isPremium = !currentValue
     }
     */
}

/// This extension is used for the extra constructors
extension DBUser {
    init(authDataUser: AuthDataResultModel) {
        self.userId = authDataUser.uid
        self.isAnonymous = authDataUser.isAnonymous
        self.email = authDataUser.email
        self.photoUrl = authDataUser.photoUrl
        self.dateCreated = Date()
        self.isPremium = false
        self.preferences = nil
        self.favoriteMovie = nil
        self.favorite_products = nil
    }
}

final class UserManager {
    static let shared = UserManager()
    private init() {}
    
    private let userCollection = Firestore.firestore().collection("users")
    
    /// `userDocument` is a user Object from the fields that are not nil
    private func userDocument(userID: String) -> DocumentReference {
        return userCollection.document(userID)
    }
    
    func createNewUser(from user: DBUser) throws {
        try userDocument(userID: user.userId).setData(from: user, merge: false)
    }
    
    /// Creates the user document ONLY if it doesn't already exist.
    /// Prevents overwriting existing data (favorites, preferences, etc.) on re-login.
    func createNewUserIfNeeded(from user: DBUser) async throws {
        let document = userDocument(userID: user.userId)
        let snapshot = try await document.getDocument()
        
        if snapshot.exists {
            print("[UserManager] User \(user.userId) already exists — skipping creation")
            return
        }
        
        try document.setData(from: user, merge: false)
        print("[UserManager] Created new user document for \(user.userId)")
    }
    
    func getUser(userID: String) async throws -> DBUser {
        return try await userDocument(userID: userID).getDocument(as: DBUser.self)
    }
    
    func updateUser(isPremium: Bool, for user: DBUser) async throws {
        let updates: [String: Any] = [ /// this changes only the is_premium field inside this specifc document in users collection, not all the fields in document/object
            DBUser.CodingKeys.isPremium.rawValue : isPremium
        ]
        
        try await userDocument(userID: user.userId).updateData(updates) /// for this user change the fields in `updates` map only
    }
    
    func addUserPreferences(preferences: String, for user: DBUser) async throws {
        let updates: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayUnion([preferences])
        ]
        
        try await userDocument(userID: user.userId).updateData(updates)
    }
    
    func removeUserPreferences(preferences: String, for user: DBUser) async throws {
        let updates: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayRemove([preferences])
        ]
        
        try await userDocument(userID: user.userId).updateData(updates)
    }
    
    func addFavoriteMovie(movie: Movie, for user: DBUser) async throws {
        let encodedMovie = try Firestore.Encoder().encode(movie) /// encode it since it's an object
        
        let updates: [String: Any] = [ /// string : map
            DBUser.CodingKeys.favoriteMovie.rawValue : encodedMovie
        ]
        
        try await userDocument(userID: user.userId).updateData(updates)
    }
    
    func removeFavoriteMovie(movie: Movie, for user: DBUser) async throws {
        let updates: [String: Any?] = [ /// string : map
            DBUser.CodingKeys.favoriteMovie.rawValue : FieldValue.delete()
        ]
        
        try await userDocument(userID: user.userId).updateData(updates as [AnyHashable : Any])
    }
    
    
    // MARK: - User Favorite Products
    func addFavoriteProduct(product: Product, for user: DBUser) async throws {
        let encodedProduct = try Firestore.Encoder().encode(product)
        
        let updates: [String: Any] = [ 
            DBUser.CodingKeys.favorite_products.rawValue : FieldValue.arrayUnion([encodedProduct])
        ]
        
        try await userDocument(userID: user.userId).updateData(updates)
    }
    
    func removeFavoriteProduct(product: Product, for user: DBUser) async throws {
        let encodedProduct = try Firestore.Encoder().encode(product)
        
        let updates: [String: Any] = [ 
            DBUser.CodingKeys.favorite_products.rawValue : FieldValue.arrayRemove([encodedProduct])
        ]
        
        try await userDocument(userID: user.userId).updateData(updates)
    }
    
    func getFavoriteProducts(for user: DBUser) async throws -> [Product] {
        let document = try await userDocument(userID: user.userId).getDocument()
        
        guard let favoriteProductsData = document.data()?[DBUser.CodingKeys.favorite_products.rawValue] as? [[String: Any]] else {
            return []
        }
        
        // Decode each product dictionary into a Product using Firestore.Decoder
        let decoder = Firestore.Decoder()
        var products: [Product] = []
        products.reserveCapacity(favoriteProductsData.count)
        
        for productMap in favoriteProductsData {
            do {
                let decoded = try decoder.decode(Product.self, from: productMap)
                products.append(decoded)
            } catch {
                print("[UserManager] Failed to decode favorite product: \(error)")
                continue
            }
        }
        
        return products
    }
}
