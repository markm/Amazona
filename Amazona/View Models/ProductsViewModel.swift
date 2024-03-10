//
//  ProductsViewModel.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/2/24.
//

import Foundation
import RxSwift
import RxCocoa

class ProductsViewModel {
    
    var categories: [Category] = []
    var originalProducts: [Product] = []
    
    let productsRelay = BehaviorRelay<[Product]>(value: [])
    let selectedCategoriesRelay = BehaviorRelay<[Category]>(value: [])
    let selectedSortOptionRelay = BehaviorRelay<ProductSortOption?>(value: nil)
    
    private let productService: ProductServiceProtocol
    private var lastSelectedSortOption: ProductSortOption?
    
    var selectedCategories: Observable<[Category]> {
        selectedCategoriesRelay.asObservable()
    }
    
    var products: Observable<[Product]> {
        productsRelay.asObservable()
    }
    
    var selectedSortOption: Observable<ProductSortOption?> {
        selectedSortOptionRelay.asObservable()
    }
    
    // MARK: - Initializers
    
    init(productService: ProductServiceProtocol) {
        self.productService = productService
    }
    
    // MARK: - Public Methods
    
    @MainActor
    func fetchProducts() async throws {
        let products = try await productService.fetchProducts()
        originalProducts = products
        
        /// unique the categories
        let uniqueCategoryStrings = Array(Set(products.map { $0.category }))
        categories = uniqueCategoryStrings.map { Category(name: $0) }.sorted(by: <)
        productsRelay.accept(products)
        
        /// select all categories by default
        categories.forEach { $0.isSelected.accept(true) }
        selectedCategoriesRelay.accept(categories)
    }
    
    func updateProducts(with products: [Product]) {
        if let lastSelectedSortOption {
            sortProducts(products, withSortOption: lastSelectedSortOption)
        } else {
            productsRelay.accept(products)
        }
    }
    
    func isSortOptionSelected(atIndex index: Int) -> Bool {
        /// ensure index is within bounds
        guard index >= 0 && index < kSortOptions.count else { return false }
        return kSortOptions[index] == lastSelectedSortOption
    }
    
    func selectSortOption(atIndex index: Int) {
        let selectedOption = kSortOptions[index]
        lastSelectedSortOption = selectedOption /// keep track of this for later
        selectedSortOptionRelay.accept(selectedOption)
    }
    
    func selectSortOption(_ option: ProductSortOption) {
        lastSelectedSortOption = option /// keep track of this for later
        selectedSortOptionRelay.accept(option)
    }
    
    func selectCategory(atIndex index: Int) {
        categories[index].isSelected.accept(true)
        selectedCategoriesRelay.accept(categories.filter { $0.isSelected.value })
    }
    
    func deselectCategory(atIndex index: Int) {
        categories[index].isSelected.accept(false)
        selectedCategoriesRelay.accept(categories.filter { $0.isSelected.value })
    }
    
    func sortProducts(_ products: [Product], withSortOption sortOption: ProductSortOption) {
        var sortedProducts: [Product] = []
        switch sortOption {
        case .topRated:
            sortedProducts = products.sorted { ($0.rating?.rate ?? -1) > ($1.rating?.rate ?? -1) }
        case .costHighToLow:
            sortedProducts = products.sorted { $0.price > $1.price }
        case .costLowToHigh:
            sortedProducts = products.sorted { $0.price < $1.price }
        }
        productsRelay.accept(sortedProducts)
    }
    
    func reset() {
        productsRelay.accept(originalProducts)
        categories.forEach { $0.isSelected.accept(true) }
        selectedCategoriesRelay.accept(categories)
        selectedSortOptionRelay.accept(nil)
        lastSelectedSortOption = nil
    }
}
