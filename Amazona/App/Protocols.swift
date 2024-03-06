//
//  Protocols.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/6/24.
//

import Foundation

protocol CategoryCellDelegate: AnyObject {
    func categoryCell(_ cell: CategoryCell, didTapButtonFor category: Category)
}
