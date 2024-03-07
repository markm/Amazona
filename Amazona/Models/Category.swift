//
//  Category.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/6/24.
//

import Foundation
import RxSwift
import RxCocoa

class Category: Comparable, Equatable {
    
    var name: String
    var isSelected: BehaviorRelay<Bool>
    
    init(name: String, isSelected: Bool = false) {
        self.name = name
        self.isSelected = BehaviorRelay(value: isSelected)
    }
    
    /// Protocol conformances
    static func < (lhs: Category, rhs: Category) -> Bool { lhs.name < rhs.name }
    static func == (lhs: Category, rhs: Category) -> Bool { lhs.name == rhs.name }
}



