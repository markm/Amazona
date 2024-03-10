//
//  Constants.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/2/24.
//

import Foundation


// Fonts
let kTitleFontSize: CGFloat = 26
let kLargeFontSize: CGFloat = 24
let kSmallFontSize: CGFloat = 14
let kMediumFontSize: CGFloat = 18
let kRegularFontSize: CGFloat = 16

// Padding
let kSmallPadding: CGFloat = 8
let kLargePadding: CGFloat = 24
let kMediumPadding: CGFloat = 16

// Radii
let kShadowRadius: CGFloat = 5
let kBuyNowCornerRadius: CGFloat = 25
let kDefaultCornerRadius: CGFloat = 16

// Misc Dimensions
let kBorderWidth: CGFloat = 1
let kTitleHeight: CGFloat = 60
let kShadowHeight: CGFloat = 5
let kShadowOpacity: Float = 0.5
let kToolbarHeight: CGFloat = 50
let kSmallSquareSize: CGFloat = 40
let kBuyNowButtonHeight: CGFloat = 50
let kSearchTextFieldHeight: CGFloat = 44

// Identifiers
let kCategoryCellIdentifier = "CategoryCell"
let kSortOptionCellIdentifier = "SortOptionCell"
let kSearchTextFieldIdentifier = "SearchTextField"

// Sort Options for Products
let kSortOptions = [ProductSortOption.topRated,
                    ProductSortOption.costHighToLow,
                    ProductSortOption.costLowToHigh]

// Misc Strings
let kDoneTitle = "Done"
let kResetTitle = "Reset"
let kFilterTitle = "Filter"
let kBuyNowTitle = "Buy Now"
let kFiltersTitle = "Filters"
let kEuroCurrencyCode = "EUR"
let kSortByLabelTitle = "SORT BY"
let kCategoriesTitle = "CATEGORIES"
let kSearchTextFieldPlaceholder = "Search for products"
let kDiscoverNewProductsTitle = "Discover New Products"
let kDefaultRecoverySuggestion = "Try again, or contact help@amazona.com"
let kInitNotImplementedErrorMessage = "init(coder:) has not been implemented"
