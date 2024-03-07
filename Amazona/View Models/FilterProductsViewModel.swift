//
//  FilterProductsViewModel.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/6/24.
//

import Foundation
import RxSwift
import RxCocoa

class FilterProductsViewModel {
    
    var categories: [Category]

    let sortOptions = [ProductSortOption.topRated,
                       ProductSortOption.costHighToLow,
                       ProductSortOption.costLowToHigh]
    
    private let selectedCategoriesRelay = BehaviorRelay<[Category]>(value: [])
    
    var selectedCategories: Observable<[Category]> {
        selectedCategoriesRelay.asObservable()
    }
    
    private var selectedSortOption: ProductSortOption?
    
    private let disposeBag = DisposeBag()

    // MARK: - Initializers
    
    init(categories: [Category]) {
        self.categories = categories
    }
    
    // MARK: - Public Methods
    
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

// MARK: - Category

class Category: Comparable {
    
    var name: String
    var isSelected: BehaviorRelay<Bool>
    
    init(name: String, isSelected: Bool = false) {
        self.name = name
        self.isSelected = BehaviorRelay(value: isSelected)
    }
    
    /// Comparable conformance
    static func < (lhs: Category, rhs: Category) -> Bool { lhs.name < rhs.name }
    static func == (lhs: Category, rhs: Category) -> Bool { lhs.name == rhs.name }
}



