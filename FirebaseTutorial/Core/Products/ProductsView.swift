//
//  ProductsView.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 11/02/2026.
//

import SwiftUI

struct ProductsView: View {
    @EnvironmentObject var viewModel: ProductsViewModel
    
    @State private var selectedCategory: CategoryFilter = .all
    @State private var selectedSortOption: SortOption = .noFilter
    
    private var activeCategory: String? {
        selectedCategory == .all ? nil : selectedCategory.rawValue
    }
    
    @State private var minPrice: String = ""
    @State private var maxPrice: String = ""
    
    private var activePriceRange: ClosedRange<Double>? {
        if minPrice.isEmpty && maxPrice.isEmpty {
            return nil
        }
        
        let min = Double(minPrice) ?? 0
        let max = Double(maxPrice) ?? 9999999
        
        guard min <= max else {
            return nil
        }
        
        return min...max
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                priceFilterBar
                contentGrid
            }
            .navigationTitle("Store")
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { filterMenu }
                ToolbarItem(placement: .navigationBarTrailing) { categoryMenu }
            }
            .task {
                await viewModel.getFavorites()
                await viewModel.addListenerForFavoritesIds()
                await viewModel.getAllProducts()
            }
            .onChange(of: selectedCategory)   { oldValue, newValue in
                Task {
                        await viewModel.getAllProducts(
                            descending: selectedSortOption.isDescending,
                            category: activeCategory,
                            priceRange: activePriceRange
                        )
                    }
            }
            .onChange(of: selectedSortOption) { oldValue, newValue in
                Task {
                        await viewModel.getAllProducts(
                            descending: newValue.isDescending,
                            category: activeCategory,
                            priceRange: activePriceRange
                        )
                    }
            }
            .onChange(of: viewModel.didResetFilters) { _, _ in
                selectedCategory = .all
                selectedSortOption = .noFilter
                minPrice = ""
                maxPrice = ""
            }
        }
    }
    
    
}


// MARK: - ENUMS
extension ProductsView {
    enum CategoryFilter: String, CaseIterable {
        case all = "All"
        case smartphones = "beauty"
        case laptops = "furniture"
        case fragrances = "fragrances"
        case groceries = "groceries"
        
        var displayName: String {
            self == .all ? "All Categories" : self.rawValue.capitalized
        }
    }
    
    enum SortOption: String, CaseIterable {
        case noFilter = "None"
        case priceAscending = "Price: Low to High"
        case priceDescending = "Price: High to Low"
        
        var isDescending: Bool? {
            switch self {
            case .priceAscending: return false
            case .priceDescending: return true
            case .noFilter: return nil
            }
        }
    }
}


// MARK: - Sub Views
extension ProductsView {
    private var priceFilterBar: some View {
        HStack(spacing: 12) {
            // Min Field
            priceField(title: "Min", text: $minPrice)
            
            // Separator
            Text("-")
                .foregroundColor(.secondary)
                .fontWeight(.bold)
            
            // Max Field
            priceField(title: "Max", text: $maxPrice)
            
            // Action Buttons
            HStack(spacing: 4) {
                // Clear Button (Only shows if there is text)
                if !minPrice.isEmpty || !maxPrice.isEmpty {
                    Button(role: .destructive) {
                        withAnimation {
                            minPrice = ""
                            maxPrice = ""
                            Task {
                                await viewModel.getAllProducts(descending: selectedSortOption.isDescending, category: activeCategory)
                            }
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.title3)
                    }
                }
                
                // Get Button
                Button {
                    Task {
                            await viewModel.getAllProducts(
                                descending: selectedSortOption.isDescending,
                                category: activeCategory,
                                priceRange: activePriceRange
                            )
                        }
                } label: {
                    Text("Get")
                        .fontWeight(.semibold)
                        .foregroundStyle(.green)
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .controlSize(.regular)
                .disabled(minPrice.isEmpty && maxPrice.isEmpty) // Disable if empty
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
    
    // Helper View Builder for consistent styling
    private func priceField(title: String, text: Binding<String>) -> some View {
        HStack(spacing: 4) {
            Text("$")
                .foregroundColor(.secondary)
                .font(.callout)
            
            TextField(title, text: text)
                .keyboardType(.decimalPad)
                .font(.subheadline)
        }
        .padding(10)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
        .frame(maxWidth: .infinity) // Makes fields equal width
    }
    
    private var contentGrid: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(viewModel.products) { product in
                ProductCardView(product: product)
                    .onAppear {
                        // Trigger pagination when the last item appears on screen
                        if product.id == viewModel.products.last?.id {
                            print("[View] Last product appeared — triggering getNextPage()")
                            Task {
                                await viewModel.getNextPage()
                            }
                        }
                    }
            }
        }
        .padding()
    }
    
    private var filterMenu: some View {
        Menu {
            Picker("Sort By", selection: $selectedSortOption) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
        } label: {
            Label("Sort", systemImage: "line.3.horizontal.decrease.circle")
        }
    }
    
    private var categoryMenu: some View {
        Menu {
            Picker("Category", selection: $selectedCategory) {
                ForEach(CategoryFilter.allCases, id: \.self) { category in
                    Text(category.displayName).tag(category)
                }
            }
        } label: {
            Label("Category", systemImage: "tag")
        }
    }
}

#Preview {
    ProductsView()
        .environmentObject(ProductsViewModel())
}

