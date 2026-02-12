//
//  ProductCardView.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 12/02/2026.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductCardView: View {
    @EnvironmentObject var viewModel: ProductsViewModel
    let product: Product

    
    @State private var isFavorite: Bool
    
    init(product: Product) {
        self.product = product
        // Initialize state from the passed product
        _isFavorite = State(initialValue: product.is_favorite ?? false)
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageSection
            detailsSection
        }
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onChange(of: viewModel.favoriteProducts) { oldValue, newValue in
            let currentlyInFavorites = newValue.contains(where: { $0.id == product.id })
            if isFavorite != currentlyInFavorites {
                isFavorite = currentlyInFavorites
            }
        }
    }
    
    private var imageSection: some View {
        ZStack(alignment: .top) {
            productImage
            HStack(alignment: .top) {
                favoriteButton
                Spacer()
                ratingBadge
            }
            .padding(8)
        }
    }
    
    private var productImage: some View {
        Group {
            if let first = product.images?.first,
               let url = URL(string: first) {

                WebImage(url: url)
                    .resizable()
                    .indicator(.activity)
                    .scaledToFit()
            } else {
                placeholderImage
            }
        }
        .frame(height: 160)
        .frame(maxWidth: .infinity)
        .clipped()
    }
    
    private var placeholderImage: some View {
        Color.gray.opacity(0.1)
            .overlay(Image(systemName: "photo").foregroundColor(.gray))
    }
    
    private var favoriteButton: some View {
        Button {
            isFavorite.toggle()
            
            Task {
                if isFavorite {
                    await viewModel.favoriteProduct(product)
                } else {
                    await viewModel.unfavoriteProduct(product)
                }
            }
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 14, weight: .bold))
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .foregroundColor(isFavorite ? .red : .primary)
        }
    }
    
    private var ratingBadge: some View {
        Group {
            if let rating = product.rating {
                HStack(spacing: 2) {
                    Image(systemName: "star.fill").foregroundColor(.yellow)
                    Text(String(format: "%.1f", rating))
                }
                .font(.caption2).fontWeight(.bold)
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
            }
        }
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(product.brand ?? "Unknown")
                .font(.caption2).fontWeight(.bold).foregroundColor(.secondary).textCase(.uppercase)
            
            Text(product.title ?? "Product Name")
                .font(.subheadline).fontWeight(.semibold).lineLimit(1)
            
            HStack(spacing: 6) {
                Text("$\(String(format: "%.2f", Double(product.price ?? 0)))")
                    .font(.headline).fontWeight(.bold)
                
                if let discount = product.discountPercentage, discount > 0 {
                    Text("\(Int(discount))% OFF")
                        .font(.caption2)
                        .fontWeight(.black)
                        .foregroundColor(.green)
                }
            }
        }
        .padding(10)
    }
}

