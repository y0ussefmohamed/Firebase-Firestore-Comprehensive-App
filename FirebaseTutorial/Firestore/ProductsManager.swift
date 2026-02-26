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
    
    // MARK: - Pagination
    func getAllProductsPaginated(
        count: Int,
        lastDocument: DocumentSnapshot?,
        descending: Bool?,
        category: String?,
        priceRange: ClosedRange<Double>? ) async throws -> (products: [Product], lastDocument: DocumentSnapshot?) {
        
        var query: Query = productsCollection
        
        if let category {
            print("[Pagination] Filtering by category: \(category)")
            query = query.whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
        }
        
        if let priceRange {
            print("[Pagination] Filtering by price range: \(priceRange.lowerBound) - \(priceRange.upperBound)")
            query = query
                .whereField(Product.CodingKeys.price.rawValue, isGreaterThanOrEqualTo: priceRange.lowerBound)
                .whereField(Product.CodingKeys.price.rawValue, isLessThanOrEqualTo: priceRange.upperBound)
        }
        
        if let descending {
            print("[Pagination] Sorting by price, descending: \(descending)")
            query = query.order(by: Product.CodingKeys.price.rawValue, descending: descending)
        } else if priceRange != nil {
            query = query.order(by: Product.CodingKeys.price.rawValue, descending: false)
        }
        
        query = query
            .limit(to: count)
            .startOptionally(afterDocument: lastDocument)
        
        print("[Pagination] Fetching page | limit: \(count) | hasLastDocument: \(lastDocument != nil)")
        
        let result = try await query.getDocumentsWithSnapshot(as: Product.self)
        
        print("[Pagination] Fetched \(result.products.count) products")
        
        return result
    }
}

// MARK: - Used Before Pagination
extension ProductsManager {
    func uploadProduct(product: Product) async throws {
        try productDocument(productId: String(product.id)).setData(from: product, merge: false)
    }
    
    func uploadProductsToFirebase(products: [Product]) async throws {
        for product in products {
            try await uploadProduct(product: product)
        }
    }
    func getProduct(productId: String) async throws -> Product {
        return try await productDocument(productId: productId)
            .getDocument(as: Product.self)
    }
    
    func getAllProducts() async throws -> [Product] {
        return try await productsCollection
            .getDocuments(as: Product.self)
    }
    
    // MARK: - Queries (Old Non-Paginated Functions)
    func getProductsSortedByPrice(descending: Bool = false) async throws -> [Product] {
        return try await productsCollection
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
            .getDocuments(as: Product.self)
    }
    
    func getProductsForCategory(category: String) async throws -> [Product] {
        return try await productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .getDocuments(as: Product.self)
    }
    
    /// `indexing` in Firestore should be enabled for this function to work properly
    func getProductsByPriceForCategory(descending: Bool, category: String) async throws -> [Product] {
        return try await productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
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
    
}
