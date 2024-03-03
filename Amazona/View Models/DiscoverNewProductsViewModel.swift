//
//  DiscoverNewProductsViewModel.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/2/24.
//

import Foundation

class DiscoverNewProductsViewModel {
    
    private let productService = ProductService()
    
    func fetchProducts() async throws -> [Product] {
        return try await productService.fetchProducts()
    }
}
