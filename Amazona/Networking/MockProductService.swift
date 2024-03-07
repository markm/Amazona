//
//  MockProductService.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/7/24.
//

import Foundation

class MockProductService: ProductServiceProtocol {
    
    var expectedProducts: [Product] = []
    var fetchProductsShouldFail: Bool = false
    
    var mockProducs: [Product] {
        return [
            Product(id: 1,
                    title: "Product A",
                    price: 50.0,
                    descriptionText: "Description A",
                    category: "Category A",
                    imageURLString: "",
                    rating: Rating(rate: 4.0, count: 200)),
            Product(id: 2,
                    title: "Product B",
                    price: 30.0,
                    descriptionText: "Description B",
                    category: "Category B",
                    imageURLString: "",
                    rating: Rating(rate: 5.0, count: 100)),
            Product(id: 3,
                    title: "Product C",
                    price: 20.0,
                    descriptionText: "Description C",
                    category: "Category C",
                    imageURLString: "",
                    rating: Rating(rate: 3.0, count: 300))
        ]
    }
    
    func fetchProducts() async throws -> [Product] {
        if fetchProductsShouldFail {
            throw NSError(domain: "com.example", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock fetch products failed"])
        }
        return expectedProducts
    }
}
