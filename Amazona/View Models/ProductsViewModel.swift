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
    
    let sortOptions = [ProductSortOption.topRated,
                       ProductSortOption.costHighToLow,
                       ProductSortOption.costLowToHigh]
    
    private let productService = ProductService()
    private var selectedSortOption: ProductSortOption?
    
    private let productsRelay = BehaviorRelay<[Product]>(value: [])
    private let selectedCategoriesRelay = BehaviorRelay<[Category]>(value: [])
    
    var selectedCategories: Observable<[Category]> {
        selectedCategoriesRelay.asObservable()
    }
    
    var products: Observable<[Product]> {
        productsRelay.asObservable()
    }
    
    // MARK: - Public Methods
    
    @MainActor
    func fetchProducts() async throws {
        let products = try await productService.fetchProducts()
        originalProducts = products
        
        // unique the categories
        let uniqueCategoryStrings = Array(Set(products.map { $0.category }))
        categories = uniqueCategoryStrings.map { Category(name: $0) }.sorted(by: <)
        productsRelay.accept(products)
        
        // select all categories by default
        categories.forEach { $0.isSelected.accept(true) }
        selectedCategoriesRelay.accept(categories)
    }
    
    func updateProducts(with products: [Product]) {
        productsRelay.accept(products)
    }
    
    func isSortOptionSelected(atIndex index: Int) -> Bool {
        selectedSortOption == sortOptions[index]
    }
    
    func selectSortOption(atIndex index: Int) {
        selectedSortOption = sortOptions[index]
    }
    
    func selectCategory(atIndex index: Int) {
        categories[index].isSelected.accept(true)
        selectedCategoriesRelay.accept(categories.filter { $0.isSelected.value })
    }
    
    func deselectCategory(atIndex index: Int) {
        categories[index].isSelected.accept(false)
        selectedCategoriesRelay.accept(categories.filter { $0.isSelected.value })
    }
    
    func setSelectedCategories(_ categories: [Category]) {
        selectedCategoriesRelay.accept(categories)
    }
}
