//
//  ProductsDatabase.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Nick Sarno on 1/22/23.
//

import Foundation

struct ProductArray: Codable {
    let products: [Product]
    let total, skip, limit: Int
}

struct Product: Identifiable, Codable, Equatable {
    let id: Int
    let title: String?
    let description: String?
    let price: Double?
    let discountPercentage: Double?
    let rating: Double?
    let stock: Int?
    let brand, category: String?
    let thumbnail: String?
    let images: [String]?
    let is_favorite: Bool?
    
    // init without is_favorite
    init(id: Int, title: String?, description: String?, price: Double?, discountPercentage: Double?, rating: Double?, stock: Int?, brand: String?, category: String?, thumbnail: String?, images: [String]?) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.discountPercentage = discountPercentage
        self.rating = rating
        self.stock = stock
        self.brand = brand
        self.category = category
        self.thumbnail = thumbnail
        self.images = images
        self.is_favorite = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case price
        case discountPercentage
        case rating
        case stock
        case brand
        case category
        case thumbnail
        case images
        case is_favorite
    }
    
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    
}

//    func downloadProductsAndUploadToFirebase() {
//        guard let url = URL(string: "https://dummyjson.com/products") else { return }
//
//        Task {
//            do {
//                let (data, _) = try await URLSession.shared.data(from: url)
//                let products = try JSONDecoder().decode(ProductArray.self, from: data)
//                let productArray = products.products
//
//                for product in productArray {
//                    try? await ProductsManager.shared.uploadProduct(product: product)
//                }
//
//                print("SUCCESS")
//                print(products.products.count)
//            } catch {
//                print(error)
//            }
//        }
//    }


final class ProductsDatabase {
    
    static let products: [Product] = [
        Product(
            id: 1,
            title: "Essence Mascara Lash Princess",
            description: "The Essence Mascara Lash Princess is a popular mascara known for its volumizing and lengthening effects. Achieve dramatic lashes with this long-lasting and cruelty-free formula.",
            price: 10, // Rounded from 9.99
            discountPercentage: 10.48,
            rating: 2.56,
            stock: 99,
            brand: "Essence",
            category: "beauty",
            thumbnail: "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp",
            images: ["https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/1.webp"]
        ),
        Product(
            id: 2,
            title: "Eyeshadow Palette with Mirror",
            description: "The Eyeshadow Palette with Mirror offers a versatile range of eyeshadow shades for creating stunning eye looks. With a built-in mirror, it's convenient for on-the-go makeup application.",
            price: 20, // Rounded from 19.99
            discountPercentage: 18.19,
            rating: 2.86,
            stock: 34,
            brand: "Glamour Beauty",
            category: "beauty",
            thumbnail: "https://cdn.dummyjson.com/product-images/beauty/eyeshadow-palette-with-mirror/thumbnail.webp",
            images: ["https://cdn.dummyjson.com/product-images/beauty/eyeshadow-palette-with-mirror/1.webp"]
        ),
        Product(
            id: 3,
            title: "Powder Canister",
            description: "The Powder Canister is a finely milled setting powder designed to set makeup and control shine. With a lightweight and translucent formula, it provides a smooth and matte finish.",
            price: 15, // Rounded from 14.99
            discountPercentage: 9.84,
            rating: 4.64,
            stock: 89,
            brand: "Velvet Touch",
            category: "beauty",
            thumbnail: "https://cdn.dummyjson.com/product-images/beauty/powder-canister/thumbnail.webp",
            images: ["https://cdn.dummyjson.com/product-images/beauty/powder-canister/1.webp"]
        ),
        Product(
            id: 4,
            title: "Red Lipstick",
            description: "The Red Lipstick is a classic and bold choice for adding a pop of color to your lips. With a creamy and pigmented formula, it provides a vibrant and long-lasting finish.",
            price: 13, // Rounded from 12.99
            discountPercentage: 12.16,
            rating: 4.36,
            stock: 91,
            brand: "Chic Cosmetics",
            category: "beauty",
            thumbnail: "https://cdn.dummyjson.com/product-images/beauty/red-lipstick/thumbnail.webp",
            images: ["https://cdn.dummyjson.com/product-images/beauty/red-lipstick/1.webp"]
        ),
        Product(
            id: 5,
            title: "Red Nail Polish",
            description: "The Red Nail Polish offers a rich and glossy red hue for vibrant and polished nails. With a quick-drying formula, it provides a salon-quality finish at home.",
            price: 9, // Rounded from 8.99
            discountPercentage: 11.44,
            rating: 4.32,
            stock: 79,
            brand: "Nail Couture",
            category: "beauty",
            thumbnail: "https://cdn.dummyjson.com/product-images/beauty/red-nail-polish/thumbnail.webp",
            images: ["https://cdn.dummyjson.com/product-images/beauty/red-nail-polish/1.webp"]
        ),
        Product(
            id: 6,
            title: "Calvin Klein CK One",
            description: "CK One by Calvin Klein is a classic unisex fragrance, known for its fresh and clean scent. It's a versatile fragrance suitable for everyday wear.",
            price: 50, // Rounded from 49.99
            discountPercentage: 1.89,
            rating: 4.37,
            stock: 29,
            brand: "Calvin Klein",
            category: "fragrances",
            thumbnail: "https://cdn.dummyjson.com/product-images/fragrances/calvin-klein-ck-one/thumbnail.webp",
            images: [
                "https://cdn.dummyjson.com/product-images/fragrances/calvin-klein-ck-one/1.webp",
                "https://cdn.dummyjson.com/product-images/fragrances/calvin-klein-ck-one/2.webp",
                "https://cdn.dummyjson.com/product-images/fragrances/calvin-klein-ck-one/3.webp"
            ]
        ),
        Product(
            id: 7,
            title: "Chanel Coco Noir Eau De",
            description: "Coco Noir by Chanel is an elegant and mysterious fragrance, featuring notes of grapefruit, rose, and sandalwood. Perfect for evening occasions.",
            price: 130, // Rounded from 129.99
            discountPercentage: 16.51,
            rating: 4.26,
            stock: 58,
            brand: "Chanel",
            category: "fragrances",
            thumbnail: "https://cdn.dummyjson.com/product-images/fragrances/chanel-coco-noir-eau-de/thumbnail.webp",
            images: [
                "https://cdn.dummyjson.com/product-images/fragrances/chanel-coco-noir-eau-de/1.webp",
                "https://cdn.dummyjson.com/product-images/fragrances/chanel-coco-noir-eau-de/2.webp",
                "https://cdn.dummyjson.com/product-images/fragrances/chanel-coco-noir-eau-de/3.webp"
            ]
        ),
        Product(
            id: 8,
            title: "Dior J'adore",
            description: "J'adore by Dior is a luxurious and floral fragrance, known for its blend of ylang-ylang, rose, and jasmine. It embodies femininity and sophistication.",
            price: 90, // Rounded from 89.99
            discountPercentage: 14.72,
            rating: 3.8,
            stock: 98,
            brand: "Dior",
            category: "fragrances",
            thumbnail: "https://cdn.dummyjson.com/product-images/fragrances/dior-j'adore/thumbnail.webp",
            images: [
                "https://cdn.dummyjson.com/product-images/fragrances/dior-j'adore/1.webp",
                "https://cdn.dummyjson.com/product-images/fragrances/dior-j'adore/2.webp",
                "https://cdn.dummyjson.com/product-images/fragrances/dior-j'adore/3.webp"
            ]
        ),
        Product(
            id: 9,
            title: "Dolce Shine Eau de",
            description: "Dolce Shine by Dolce & Gabbana is a vibrant and fruity fragrance, featuring notes of mango, jasmine, and blonde woods. It's a joyful and youthful scent.",
            price: 70, // Rounded from 69.99
            discountPercentage: 0.62,
            rating: 3.96,
            stock: 4,
            brand: "Dolce & Gabbana",
            category: "fragrances",
            thumbnail: "https://cdn.dummyjson.com/product-images/fragrances/dolce-shine-eau-de/thumbnail.webp",
            images: [
                "https://cdn.dummyjson.com/product-images/fragrances/dolce-shine-eau-de/1.webp",
                "https://cdn.dummyjson.com/product-images/fragrances/dolce-shine-eau-de/2.webp",
                "https://cdn.dummyjson.com/product-images/fragrances/dolce-shine-eau-de/3.webp"
            ]
        ),
        Product(
            id: 10,
            title: "Gucci Bloom Eau de",
            description: "Gucci Bloom by Gucci is a floral and captivating fragrance, with notes of tuberose, jasmine, and Rangoon creeper. It's a modern and romantic scent.",
            price: 80, // Rounded from 79.99
            discountPercentage: 14.39,
            rating: 2.74,
            stock: 91,
            brand: "Gucci",
            category: "fragrances",
            thumbnail: "https://cdn.dummyjson.com/product-images/fragrances/gucci-bloom-eau-de/thumbnail.webp",
            images: [
                "https://cdn.dummyjson.com/product-images/fragrances/gucci-bloom-eau-de/1.webp",
                "https://cdn.dummyjson.com/product-images/fragrances/gucci-bloom-eau-de/2.webp",
                "https://cdn.dummyjson.com/product-images/fragrances/gucci-bloom-eau-de/3.webp"
            ]
        ),
        Product(
            id: 11,
            title: "Annibale Colombo Bed",
            description: "The Annibale Colombo Bed is a luxurious and elegant bed frame, crafted with high-quality materials for a comfortable and stylish bedroom.",
            price: 1900, // Rounded from 1899.99
            discountPercentage: 8.57,
            rating: 4.77,
            stock: 88,
            brand: "Annibale Colombo",
            category: "furniture",
            thumbnail: "https://cdn.dummyjson.com/product-images/furniture/annibale-colombo-bed/thumbnail.webp",
            images: [
                "https://cdn.dummyjson.com/product-images/furniture/annibale-colombo-bed/1.webp",
                "https://cdn.dummyjson.com/product-images/furniture/annibale-colombo-bed/2.webp",
                "https://cdn.dummyjson.com/product-images/furniture/annibale-colombo-bed/3.webp"
            ]
        ),
        Product(
            id: 12,
            title: "Annibale Colombo Sofa",
            description: "The Annibale Colombo Sofa is a sophisticated and comfortable seating option, featuring exquisite design and premium upholstery for your living room.",
            price: 2500, // Rounded from 2499.99
            discountPercentage: 14.4,
            rating: 3.92,
            stock: 60,
            brand: "Annibale Colombo",
            category: "furniture",
            thumbnail: "https://cdn.dummyjson.com/product-images/furniture/annibale-colombo-sofa/thumbnail.webp",
            images: [
                "https://cdn.dummyjson.com/product-images/furniture/annibale-colombo-sofa/1.webp",
                "https://cdn.dummyjson.com/product-images/furniture/annibale-colombo-sofa/2.webp",
                "https://cdn.dummyjson.com/product-images/furniture/annibale-colombo-sofa/3.webp"
            ]
        ),
        Product(
            id: 13,
            title: "Bedside Table African Cherry",
            description: "The Bedside Table in African Cherry is a stylish and functional addition to your bedroom, providing convenient storage space and a touch of elegance.",
            price: 300, // Rounded from 299.99
            discountPercentage: 19.09,
            rating: 2.87,
            stock: 64,
            brand: "Furniture Co.",
            category: "furniture",
            thumbnail: "https://cdn.dummyjson.com/product-images/furniture/bedside-table-african-cherry/thumbnail.webp",
            images: [
                "https://cdn.dummyjson.com/product-images/furniture/bedside-table-african-cherry/1.webp",
                "https://cdn.dummyjson.com/product-images/furniture/bedside-table-african-cherry/2.webp",
                "https://cdn.dummyjson.com/product-images/furniture/bedside-table-african-cherry/3.webp"
            ]
        ),
        Product(
            id: 14,
            title: "Knoll Saarinen Executive Conference Chair",
            description: "The Knoll Saarinen Executive Conference Chair is a modern and ergonomic chair, perfect for your office or conference room with its timeless design.",
            price: 500, // Rounded from 499.99
            discountPercentage: 2.01,
            rating: 4.88,
            stock: 26,
            brand: "Knoll",
            category: "furniture",
            thumbnail: "https://cdn.dummyjson.com/product-images/furniture/knoll-saarinen-executive-conference-chair/thumbnail.webp",
            images: [
                "https://cdn.dummyjson.com/product-images/furniture/knoll-saarinen-executive-conference-chair/1.webp",
                "https://cdn.dummyjson.com/product-images/furniture/knoll-saarinen-executive-conference-chair/2.webp",
                "https://cdn.dummyjson.com/product-images/furniture/knoll-saarinen-executive-conference-chair/3.webp"
            ]
        ),
        Product(
            id: 15,
            title: "Wooden Bathroom Sink With Mirror",
            description: "The Wooden Bathroom Sink with Mirror is a unique and stylish addition to your bathroom, featuring a wooden sink countertop and a matching mirror.",
            price: 800, // Rounded from 799.99
            discountPercentage: 8.8,
            rating: 3.59,
            stock: 7,
            brand: "Bath Trends",
            category: "furniture",
            thumbnail: "https://cdn.dummyjson.com/product-images/furniture/wooden-bathroom-sink-with-mirror/thumbnail.webp",
            images: [
                "https://cdn.dummyjson.com/product-images/furniture/wooden-bathroom-sink-with-mirror/1.webp",
                "https://cdn.dummyjson.com/product-images/furniture/wooden-bathroom-sink-with-mirror/2.webp",
                "https://cdn.dummyjson.com/product-images/furniture/wooden-bathroom-sink-with-mirror/3.webp"
            ]
        ),
        Product(
            id: 16,
            title: "Apple",
            description: "Fresh and crisp apples, perfect for snacking or incorporating into various recipes.",
            price: 2, // Rounded from 1.99
            discountPercentage: 12.62,
            rating: 4.19,
            stock: 8,
            brand: nil, // API JSON didn't have brand for groceries sometimes, or I checked and didn't see one.
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/product-images/groceries/apple/thumbnail.webp",
            images: ["https://cdn.dummyjson.com/product-images/groceries/apple/1.webp"]
        ),
        Product(
            id: 17,
            title: "Beef Steak",
            description: "High-quality beef steak, great for grilling or cooking to your preferred level of doneness.",
            price: 13, // Rounded from 12.99
            discountPercentage: 9.61,
            rating: 4.47,
            stock: 86,
            brand: nil,
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/product-images/groceries/beef-steak/thumbnail.webp",
            images: ["https://cdn.dummyjson.com/product-images/groceries/beef-steak/1.webp"]
        ),
        Product(
            id: 18,
            title: "Cat Food",
            description: "Nutritious cat food formulated to meet the dietary needs of your feline friend.",
            price: 9, // Rounded from 8.99
            discountPercentage: 9.58,
            rating: 3.13,
            stock: 46,
            brand: nil,
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/product-images/groceries/cat-food/thumbnail.webp",
            images: ["https://cdn.dummyjson.com/product-images/groceries/cat-food/1.webp"]
        ),
        Product(
            id: 19,
            title: "Chicken Meat",
            description: "Fresh and tender chicken meat, suitable for various culinary preparations.",
            price: 10, // Rounded from 9.99
            discountPercentage: 13.7,
            rating: 3.19,
            stock: 97,
            brand: nil,
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/product-images/groceries/chicken-meat/thumbnail.webp",
            images: [
                "https://cdn.dummyjson.com/product-images/groceries/chicken-meat/1.webp",
                "https://cdn.dummyjson.com/product-images/groceries/chicken-meat/2.webp"
            ]
        ),
        Product(
            id: 20,
            title: "Cooking Oil",
            description: "Versatile cooking oil suitable for frying, sautéing, and various culinary applications.",
            price: 5, // Rounded from 4.99
            discountPercentage: 9.33,
            rating: 4.8,
            stock: 10,
            brand: nil,
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/product-images/groceries/cooking-oil/thumbnail.webp",
            images: ["https://cdn.dummyjson.com/product-images/groceries/cooking-oil/1.webp"]
        ),
        Product(
            id: 21,
            title: "Cucumber",
            description: "Crisp and hydrating cucumbers, ideal for salads, snacks, or as a refreshing side.",
            price: 1, // Rounded from 1.49
            discountPercentage: 0.16,
            rating: 4.07,
            stock: 84,
            brand: nil,
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/product-images/groceries/cucumber/thumbnail.webp",
            images: ["https://cdn.dummyjson.com/product-images/groceries/cucumber/1.webp"]
        ),
        Product(
            id: 22,
            title: "Dog Food",
            description: "Specially formulated dog food designed to provide essential nutrients for your canine companion.",
            price: 11, // Rounded from 10.99
            discountPercentage: 10.27,
            rating: 4.55,
            stock: 71,
            brand: nil,
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/product-images/groceries/dog-food/thumbnail.webp",
            images: ["https://cdn.dummyjson.com/product-images/groceries/dog-food/1.webp"]
        ),
        Product(
            id: 23,
            title: "Eggs",
            description: "Fresh eggs, a versatile ingredient for baking, cooking, or breakfast.",
            price: 3, // Rounded from 2.99
            discountPercentage: 11.05,
            rating: 2.53,
            stock: 9,
            brand: nil,
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/product-images/groceries/eggs/thumbnail.webp",
            images: ["https://cdn.dummyjson.com/product-images/groceries/eggs/1.webp"]
        ),
        Product(
            id: 24,
            title: "Fish Steak",
            description: "Quality fish steak, suitable for grilling, baking, or pan-searing.",
            price: 15, // Rounded from 14.99
            discountPercentage: 4.23,
            rating: 3.78,
            stock: 74,
            brand: nil,
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/product-images/groceries/fish-steak/thumbnail.webp",
            images: ["https://cdn.dummyjson.com/product-images/groceries/fish-steak/1.webp"]
        ),
        Product(
            id: 25,
            title: "Green Bell Pepper",
            description: "Fresh and vibrant green bell pepper, perfect for adding color and flavor to your dishes.",
            price: 1, // Rounded from 1.29
            discountPercentage: 0.16,
            rating: 3.25,
            stock: 33,
            brand: nil,
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/product-images/groceries/green-bell-pepper/thumbnail.webp",
            images: ["https://cdn.dummyjson.com/product-images/groceries/green-bell-pepper/1.webp"]
        ),
        Product(
            id: 26,
            title: "Green Chili Pepper",
            description: "Spicy green chili pepper, ideal for adding heat to your favorite recipes.",
            price: 1, // Rounded from 0.99
            discountPercentage: 1.0,
            rating: 3.66,
            stock: 3,
            brand: nil,
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/product-images/groceries/green-chili-pepper/thumbnail.webp",
            images: ["https://cdn.dummyjson.com/product-images/groceries/green-chili-pepper/1.webp"]
        ),
        Product(
            id: 27,
            title: "Honey Jar",
            description: "Pure and natural honey in a convenient jar, perfect for sweetening beverages or drizzling over food.",
            price: 7, // Rounded from 6.99
            discountPercentage: 14.4,
            rating: 3.97,
            stock: 34,
            brand: nil,
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/product-images/groceries/honey-jar/thumbnail.webp",
            images: ["https://cdn.dummyjson.com/product-images/groceries/honey-jar/1.webp"]
        ),
        Product(
            id: 28,
            title: "Ice Cream",
            description: "Creamy and delicious ice cream, available in various flavors for a delightful treat.",
            price: 5, // Rounded from 5.49
            discountPercentage: 8.69,
            rating: 3.39,
            stock: 27,
            brand: nil,
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/product-images/groceries/ice-cream/thumbnail.webp",
            images: [
                "https://cdn.dummyjson.com/product-images/groceries/ice-cream/1.webp",
                "https://cdn.dummyjson.com/product-images/groceries/ice-cream/2.webp",
                "https://cdn.dummyjson.com/product-images/groceries/ice-cream/3.webp",
                "https://cdn.dummyjson.com/product-images/groceries/ice-cream/4.webp"
            ]
        ),
        Product(
            id: 29,
            title: "Juice",
            description: "Refreshing fruit juice, packed with vitamins and great for staying hydrated.",
            price: 4, // Rounded from 3.99
            discountPercentage: 12.06,
            rating: 3.94,
            stock: 50,
            brand: nil,
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/product-images/groceries/juice/thumbnail.webp",
            images: ["https://cdn.dummyjson.com/product-images/groceries/juice/1.webp"]
        ),
        Product(
            id: 30,
            title: "Kiwi",
            description: "Nutrient-rich kiwi, perfect for snacking or adding a tropical twist to your dishes.",
            price: 2, // Rounded from 2.49
            discountPercentage: 15.22,
            rating: 4.93,
            stock: 99,
            brand: nil,
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/product-images/groceries/kiwi/thumbnail.webp",
            images: ["https://cdn.dummyjson.com/product-images/groceries/kiwi/1.webp"]
        )
    ]
}

