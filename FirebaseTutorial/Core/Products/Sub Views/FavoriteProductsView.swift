//
//  FavoriteProductsView.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 12/02/2026.
//

import SwiftUI
import SDWebImageSwiftUI


struct FavoriteProductsView: View {
    @EnvironmentObject private var viewModel: ProductsViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.favoriteProducts.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(Array(viewModel.favoriteProducts.enumerated()), id: \.element.id) { index, product in
                            FavoriteRow(product: product)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        let productToRemove = viewModel.favoriteProducts[index]
                                        Task {
                                            await viewModel.unfavoriteProduct(productToRemove)
                                        }
                                    } label: {
                                        Label("Remove", systemImage: "heart.slash")
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Favorites")
            .task {
                await viewModel.getFavorites()
            }
        }
    }
    
    // MARK: - Subviews
    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Favorites Yet", systemImage: "heart.fill")
        } description: {
            Text("Tap the heart icon on products to see them here.")
        }
    }
}


#Preview {
    FavoriteProductsView()
        .environmentObject(ProductsViewModel())
}
