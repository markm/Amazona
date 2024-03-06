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
    
    /// Inputs
    var categories: [Category]
    let selection = PublishSubject<IndexPath>()

    /// Outputs
    var selectedCategory: Observable<Category>

    let sortOptions = [ProductSortOption.topRated,
                       ProductSortOption.costHighToLow,
                       ProductSortOption.costLowToHigh]
    
    private var selectedSortOptions: [ProductSortOption] = []
    
    private let disposeBag = DisposeBag()

    init(categories: [Category]) {
        self.categories = categories
        /// Temporarily set selectedCategory to an empty Observable until it's properly initialized
        self.selectedCategory = Observable.empty()

        /// Properly initialize selectedCategory now that self is fully available
        self.selectedCategory = selection
            .map { [unowned self] indexPath in self.categories[indexPath.row] }
        
        setupBindings()
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

    private func setupBindings() {
        selectedCategory
            .subscribe(onNext: { [weak self] category in
                guard let self = self else { return }
                
                /// Toggle the isSelected state for the selected category
                category.isSelected.accept(!category.isSelected.value)
                
                /// Optionally, deselect all other categories
                self.categories.enumerated().forEach { index, otherCategory in
                    if otherCategory !== category {
                        otherCategory.isSelected.accept(false)
                    }
                }
            })
            .disposed(by: disposeBag)
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



