//
//  FavoriteRow.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 12/02/2026.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavoriteRow: View {
    let product: Product
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            WebImage(url: URL(string: product.thumbnail ?? ""))
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(product.title ?? "Unknown Product")
                    .font(.headline)
                    .lineLimit(1)
                
                HStack {
                    Text("$\(product.price ?? 0, specifier: "%.2f")")
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)
                    
                    if let discount = product.discountPercentage, discount > 0 {
                        Text("\(Int(discount))% OFF")
                            .font(.caption2.bold())
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.red.opacity(0.1))
                            .foregroundColor(.red)
                            .cornerRadius(4)
                    }
                }
                
                Text(product.category?.capitalized ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption2.bold())
                .foregroundStyle(.quaternary)
        }
        .padding(.vertical, 4)
    }
}
