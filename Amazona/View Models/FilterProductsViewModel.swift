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
    
    private var selectedSortOptions: [ProductSortOption] = []
    
    private let disposeBag = DisposeBag()

    init(categories: [Category]) {
        self.categories = categories
    }
    
    func isSortOptionSelected(atIndex index: Int) -> Bool {
        selectedSortOptions.contains(sortOptions[index])
    }
    
    func selectSortOption(atIndex index: Int) {
        selectedSortOptions.removeAll()
        if isSortOptionSelected(atIndex: index) == false {
            selectedSortOptions.append(sortOptions[index])
        }
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



