//
//  ProductsViewModel.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 11/02/2026.
//

import Foundation
import Combine

@MainActor
final class ProductsViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var favoriteProducts: [Product] = []
    
    let productsManager = ProductsManager.shared
    
    
    /// Use it one time just to put products on firestore
    /*
     func seedDatabase() {
        Task {
            do {
                let products = ProductsDatabase.products
                try await ProductsManager.shared.uploadProductsToFirebase(products: products)
                print("Successfully uploaded \(products.count) products!")
            } catch {
                print("Error seeding database: \(error)")
            }
        }
    }
     */
    
    func getAllProducts() async throws {
        self.products = try await productsManager.getAllProducts()
    }
    
    // MARK: - Queries
    func getProductsSortedByPrice(descending: Bool) {
        Task {
            do {
                self.products = try await productsManager.getProductsSortedByPrice(descending: descending)
            } catch {
                print(error)
            }
        }
    }
    
    func getProductsForCategory(_ category: String) {
        Task {
            do {
                self.products = try await productsManager.getProductsForCategory(category: category)
            } catch {
                print(error)
            }
        }
    }
    
    func getProductsByPriceForCategory(descending: Bool, category: String) {
        Task {
            do {
                self.products = try await productsManager
                    .getProductsByPriceForCategory(descending: descending, category: category)
            } catch {
                print(error)
            }
        }
    }
    
    func getProductsByRating(count: Int) {
        Task {
            do {
                self.products = try await productsManager.getProductsByRating(count: count)
            } catch {
                print(error)
            }
        }
    }
    
    func getProductsByPriceRange(startAt: Double, endAt: Double) {
        Task {
            do {
                self.products = try await productsManager.getProductsByPriceRange(minimum: startAt, maximum: endAt)
            } catch {
                print(error)
            }
        }
    }
    
    func getProductsByPriceRangeWithSortingOption(startAt: Double, endAt: Double, sortOption: Bool) {
        Task {
            do {
                self.products = try await productsManager
                    .getProductsByPriceRangeWithSortingOption(minimum: startAt, maximum: endAt,sortOption: sortOption)
            } catch {
                print(error)
            }
        }
    }
    
    func getProductsByPriceRangeForCategory(startAt: Double, endAt: Double, category: String) {
        Task {
            do {
                self.products = try await productsManager
                    .getProductsByPriceRangeForCategory(minimum: startAt, maximum: endAt, category: category)
            } catch {
                print(error)
            }
        }
    }
    
    func getProductsByPriceRangeWithSortingOptionForCategory(startAt: Double, endAt: Double, category: String, sortOption: Bool) {
        Task {
            do {
                self.products = try await productsManager
                    .getProductsByPriceRangeWithSortingOptionForCategory(minimum: startAt, maximum: endAt, category: category,sortOption: sortOption)
            } catch {
                print(error)
            }
        }
    }
    // MARK: - Favorite
    func favoriteProduct(_ product: Product) async {
        try? await productsManager.favoriteProduct(productId: String(product.id))
    }
    
    func unfavoriteProduct(_ product: Product) async {
        try? await productsManager.unfavoriteProduct(productId: String(product.id))
        self.favoriteProducts.removeAll(where: { $0.id == product.id })
    }
    
    func getFavorites() async {
        do {
            self.favoriteProducts = try await productsManager.getFavoriteProducts()
        } catch {
            print(error)
        }
    }
}
