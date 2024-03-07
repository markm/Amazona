//
//  DiscoverNewProductsViewModel.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/2/24.
//

import Foundation
import RxSwift
import RxCocoa

class DiscoverNewProductsViewModel {
    
    var categories: [Category] = []
    var originalProducts: [Product] = []
    
    private let productService = ProductService()
    private let productsRelay = BehaviorRelay<[Product]>(value: [])
    
    var products: Observable<[Product]> {
        productsRelay.asObservable()
    }
    
    @MainActor
    func fetchProducts() async throws {
        let products = try await productService.fetchProducts()
        originalProducts = products
        /// get a uniqued list of categories from the products and sort them alphabetically
        let uniqueCategoryStrings = Array(Set(products.map { $0.category }))
        categories = uniqueCategoryStrings.map { Category(name: $0) }.sorted(by: <)
        productsRelay.accept(products)
    }
    
    func updateProducts(with products: [Product]) {
        productsRelay.accept(products)
    }
}
