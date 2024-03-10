//
//  AppImages.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/10/24.
//

import Foundation
import UIKit

// Usage: let magnifyingGlassImage = AppImages.magnifyingGlass

struct AppImages {
    static var magnifyingGlass: UIImage? {
        UIImage(systemName: "magnifyingglass")
    }

    static var filter: UIImage? {
        UIImage(systemName: "line.3.horizontal.decrease.circle.fill")
    }
    
    static var starFilled: UIImage? {
        UIImage(systemName: "star.fill")
    }
}
