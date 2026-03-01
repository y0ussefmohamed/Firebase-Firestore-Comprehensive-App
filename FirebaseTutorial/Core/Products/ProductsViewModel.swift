//
//  ProductsViewModel.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 11/02/2026.
//

import Foundation
import FirebaseFirestore
import Combine

@MainActor
final class ProductsViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var favoriteProducts: [Product] = []
    @Published private(set) var favoriteProductIds: Set<Int> = []
    
    /// Toggled when the user logs out / deletes account so the View can reset its @State filters
    @Published var didResetFilters: Bool = false
    
    let userManager = UserManager.shared
    let productsManager = ProductsManager.shared
    let authManager = AuthenticationManager.shared
    
    private var currentUser: DBUser? = nil
    
    // MARK: - Pagination State
    private(set) var lastDocument: DocumentSnapshot? = nil
    private(set) var hasMoreProducts: Bool = true
    private let pageSize: Int = 10
    
    /// Stored filters so `getNextPage()` can reuse them
    private var currentDescending: Bool? = nil
    private var currentCategory: String? = nil
    private var currentPriceRange: ClosedRange<Double>? = nil
    
    // MARK: - Core Pagination Methods
    /// Fetches the first page of products. Resets pagination state and stores the current filters.
    private func getFirstPageOfProducts(
        descending: Bool? = nil,
        category: String? = nil,
        priceRange: ClosedRange<Double>? = nil
    ) async {
        // Store filters for subsequent pages
        currentDescending = descending
        currentCategory = category
        currentPriceRange = priceRange
        
        // Reset pagination state
        products = []
        hasMoreProducts = true
        lastDocument = nil
        
        print("[ViewModel] getProducts called — resetting pagination state")
        print("[ViewModel] Filters → descending: \(String(describing: descending)), category: \(String(describing: category)), priceRange: \(String(describing: priceRange))")
        
        do {
            let result = try await productsManager.getAllProductsPaginated(
                count: pageSize,
                lastDocument: nil,
                descending: descending,
                category: category,
                priceRange: priceRange
            )
            
            self.products = result.products
            self.lastDocument = result.lastDocument
            self.hasMoreProducts = result.products.count >= pageSize
            
            print("[ViewModel] First page loaded — \(result.products.count) products | hasMore: \(hasMoreProducts)")
        } catch {
            print("[ViewModel] Error fetching first page: \(error)")
        }
    }
    
    /// Used in view .task{}, fetches the next page using the stored filters and the last document cursor.
    func getNextPage() async {
        /// Guard: don't fetch if there's nothing more or if we have no cursor yet
        guard hasMoreProducts, lastDocument != nil else {
            print("[ViewModel] getNextPage skipped — hasMoreProducts: \(hasMoreProducts), lastDocument: \(String(describing: lastDocument))")
            return
        }
        
        print("[ViewModel] getNextPage called — fetching next \(pageSize) products...")
        
        do {
            let result = try await productsManager.getAllProductsPaginated(
                count: pageSize,
                lastDocument: lastDocument,
                descending: currentDescending,
                category: currentCategory,
                priceRange: currentPriceRange
            )
            
            self.products.append(contentsOf: result.products)
            self.lastDocument = result.lastDocument
            self.hasMoreProducts = result.products.count >= pageSize
            
            print("[ViewModel] Next page loaded — \(result.products.count) new products | total: \(products.count) | hasMore: \(hasMoreProducts)")
        } catch {
            print("[ViewModel] Error fetching next page: \(error)")
        }
    }
    
    // MARK: - User State Management
    /// Must be called on logout/account deletion
    func resetUserState() {
        currentUser = nil
        favoriteProducts = []
        favoriteProductIds = []
        
        // Reset pagination filters so the next user starts fresh
        products = []
        currentDescending = nil
        currentCategory = nil
        currentPriceRange = nil
        lastDocument = nil
        hasMoreProducts = true
        
        // Signals the View to reset its @State sort/category/price fields
        didResetFilters.toggle()
        
        print("[ViewModel] User state reset — cached user, favorites, and filters cleared")
    }
    
    private func loadCurrentUser() async -> DBUser? {
        if let currentUser { return currentUser }
        
        guard let authUser = try? authManager.getAuthenticatedUser() else {
            print("[ViewModel] No authenticated user found")
            return nil
        }
        
        do {
            let user = try await userManager.getUser(userID: authUser.uid)
            self.currentUser = user
            return user
        } catch {
            print("[ViewModel] Error loading user: \(error)")
            return nil
        }
    }
    
    // MARK: - Favorite (Per-User)
    /// for `FavoritesView`
    func addListenerForFavorites() async {
        guard let user = await loadCurrentUser() else { return }
            
        userManager.addListenerForFavoriteProducts(userId: user.userId) { [weak self] returnedFavoriteProducts in
            self?.favoriteProducts = returnedFavoriteProducts
        }
    }
    
    /// for `ProductsView`
    func addListenerForFavoritesIds() async {
        guard let user = await loadCurrentUser() else { return }
            
        userManager.addListenerForFavoriteProducts(userId: user.userId) { [weak self] returnedFavoriteProducts in
            let returnedFavoriteProdcutsIds = Set(returnedFavoriteProducts.map { $0.id }) /// map products to id first
            self?.favoriteProductIds = returnedFavoriteProdcutsIds
        }
    }
    
    func favoriteProduct(_ product: Product) async {
        guard let user = await loadCurrentUser() else { return }
        
        do {
            try await userManager.addFavoriteProduct(product: product, for: user)
            self.favoriteProducts.append(product)
            self.favoriteProductIds.insert(product.id)
            print("[ViewModel] Product \(product.id) added to favorites for user \(user.userId)")
        } catch {
            print("[ViewModel] Error adding favorite: \(error)")
        }
    }
    
    func unfavoriteProduct(_ product: Product) async {
        guard let user = await loadCurrentUser() else { return }
        
        do {
            try await userManager.removeFavoriteProduct(product: product, for: user)
            self.favoriteProducts.removeAll(where: { $0.id == product.id })
            self.favoriteProductIds.remove(product.id)
            print("[ViewModel] Product \(product.id) removed from favorites for user \(user.userId)")
        } catch {
            print("[ViewModel] Error removing favorite: \(error)")
        }
    }
    
    func getFavorites() async {
        guard let user = await loadCurrentUser() else { return }
        
        do {
            let favorites = try await userManager.getFavoriteProducts(for: user)
            self.favoriteProducts = favorites
            self.favoriteProductIds = Set(favorites.map { $0.id })
            print("[ViewModel] Loaded \(favorites.count) favorite products for user \(user.userId)")
        } catch {
            print("[ViewModel] Error fetching favorites: \(error)")
        }
    }
    
    func isFavorite(_ product: Product) -> Bool {
        return favoriteProductIds.contains(product.id)
    }
}

extension ProductsViewModel {
    // MARK: - Public Query Methods (delegate to getProducts)
    func getAllProducts(descending: Bool? = nil,
                        category: String? = nil,
                        priceRange: ClosedRange<Double>? = nil) async {
        await getFirstPageOfProducts(descending: descending, category: category, priceRange: priceRange)
    }
    
    func getProductsSortedByPrice(descending: Bool) {
        Task {
            await getFirstPageOfProducts(descending: descending)
        }
    }
    
    func getProductsForCategory(_ category: String) {
        Task {
            await getFirstPageOfProducts(category: category)
        }
    }
    
    func getProductsByPriceForCategory(descending: Bool, category: String) {
        Task {
            await getFirstPageOfProducts(descending: descending, category: category)
        }
    }
    
    func getProductsByPriceRange(startAt: Double, endAt: Double) {
        Task {
            await getFirstPageOfProducts(priceRange: startAt...endAt)
        }
    }
    
    func getProductsByPriceRangeWithSortingOption(startAt: Double, endAt: Double, sortOption: Bool) {
        Task {
            await getFirstPageOfProducts(descending: sortOption, priceRange: startAt...endAt)
        }
    }
    
    func getProductsByPriceRangeForCategory(startAt: Double, endAt: Double, category: String) {
        Task {
            await getFirstPageOfProducts(category: category, priceRange: startAt...endAt)
        }
    }
    
    func getProductsByPriceRangeWithSortingOptionForCategory(startAt: Double, endAt: Double, category: String, sortOption: Bool)
    {
        Task {
            await getFirstPageOfProducts(descending: sortOption, category: category, priceRange: startAt...endAt)
        }
    }
}
