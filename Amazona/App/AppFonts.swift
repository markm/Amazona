//
//  AppFonts.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/4/24.
//

import Foundation
import UIKit

/**
 Example usage: let boldFont = AppFonts.helveticaNeue(ofSize: 18, weight: .bold)
 */
struct AppFonts {
    
    static func helveticaNeue(ofSize size: CGFloat, weight: FontWeight = .regular) -> UIFont {
        switch weight {
        case .regular:
            return UIFont(name: "HelveticaNeue", size: size) ?? UIFont.systemFont(ofSize: size)
        case .bold:
            return UIFont(name: "HelveticaNeue-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
        }
    }
}

enum FontWeight {
    case regular
    case bold
}
