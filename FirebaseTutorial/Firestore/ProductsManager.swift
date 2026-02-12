//
//  ProductsManager.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 11/02/2026.
//

import Foundation
import FirebaseFirestore
import Combine

final class ProductsManager {
    static let shared = ProductsManager()
    private init() {}
    
    private let productsCollection = Firestore.firestore().collection("products")
    private func productDocument(productId: String) -> DocumentReference {
        productsCollection.document(productId)
    }
    
    func uploadProduct(product: Product) async throws {
        try productDocument(productId: String(product.id)).setData(from: product, merge: false)
    }
    
    func uploadProductsToFirebase(products: [Product]) async throws {
        for product in products {
            try await uploadProduct(product: product)
        }
    }
    func getProduct(productId: String) async throws -> Product {
        return try await productDocument(productId: productId).getDocument(as: Product.self)
    }
    
    func getAllProducts() async throws -> [Product] {
        return try await productsCollection.getDocuments(as: Product.self)
    }
    
    // MARK: - Queries
    func getProductsSortedByPrice(descending: Bool = false) async throws -> [Product] {
        return try await productsCollection
            .order(by: Product.CodingKeys.price.rawValue, descending: descending).getDocuments(as: Product.self)
    }
    
    func getProductsForCategory(category: String) async throws -> [Product] {
        return try await productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category).getDocuments(as: Product.self)
    }
    
    /// `indexing` in Firestore should be enabled for this function to work properly
    func getProductsByPriceForCategory(descending: Bool, category: String) async throws -> [Product] {
        return try await productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
            .getDocuments(as: Product.self)
    }
    
    func getProductsByRating(count: Int) async throws -> [Product] {
        return try await productsCollection
            .order(by: Product.CodingKeys.rating.rawValue, descending: true)
            .limit(to: count)
            .getDocuments(as: Product.self)
    }
    
    func getProductsByPriceRange(minimum: Double, maximum: Double) async throws -> [Product] {
        return try await productsCollection
            .order(by: Product.CodingKeys.price.rawValue, descending: false)
            .start(at: [minimum])
            .end(at: [maximum])
            .getDocuments(as: Product.self)
    }
    
    func getProductsByPriceRangeWithSortingOption(minimum: Double, maximum: Double, sortOption: Bool) async throws -> [Product] {
        return try await productsCollection
            .whereField(Product.CodingKeys.price.rawValue, isGreaterThanOrEqualTo: minimum)
            .whereField(Product.CodingKeys.price.rawValue, isLessThanOrEqualTo: maximum)
            .order(by: Product.CodingKeys.price.rawValue, descending: sortOption)
            .getDocuments(as: Product.self)
    }
    
    func getProductsByPriceRangeWithSortingOptionForCategory(minimum: Double, maximum: Double, category: String, sortOption: Bool) async throws -> [Product] {
        return try await productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .whereField(Product.CodingKeys.price.rawValue, isGreaterThanOrEqualTo: minimum)
            .whereField(Product.CodingKeys.price.rawValue, isLessThanOrEqualTo: maximum)
            .order(by: Product.CodingKeys.price.rawValue, descending: sortOption)
            .getDocuments(as: Product.self)
    }
    
    func getProductsByPriceRangeForCategory(minimum: Double, maximum: Double, category: String) async throws -> [Product] {
        return try await productsCollection
            .whereField(Product.CodingKeys.price.rawValue, isGreaterThanOrEqualTo: minimum)
            .whereField(Product.CodingKeys.price.rawValue, isLessThanOrEqualTo: maximum)
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .getDocuments(as: Product.self)
    }
    
    // MARK: - Favorite
    func favoriteProduct(productId: String) async throws {
        let updates: [String: Any] = [
            Product.CodingKeys.is_favorite.rawValue: true
        ]
        
        try await productDocument(productId: productId).updateData(updates)
    }
    
    func unfavoriteProduct(productId: String) async throws {
        let updates: [String: Any] = [
            Product.CodingKeys.is_favorite.rawValue: false
        ]
        
        try await productDocument(productId: productId).updateData(updates)
    }
    
    func getFavoriteProducts() async throws -> [Product] {
        return try await productsCollection
            .whereField(Product.CodingKeys.is_favorite.rawValue, isEqualTo: true).getDocuments(as: Product.self)
    }
    
    // MARK: - Pagination
}


extension Query {
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        try await getDocumentsWithSnapshot(as: type).products
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (products: [T], lastDocument: DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        let products = try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
        
        return (products, snapshot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else { return self }
        return self.start(afterDocument: lastDocument)
    }
    
    func addSnapshotListener<T>(as type: T.Type) -> (AnyPublisher<[T], Error>, ListenerRegistration) where T : Decodable {
        let publisher = PassthroughSubject<[T], Error>()
        
        let listener = self.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            let products: [T] = documents.compactMap({ try? $0.data(as: T.self) })
            publisher.send(products)
        }
        
        return (publisher.eraseToAnyPublisher(), listener)
    }
}
