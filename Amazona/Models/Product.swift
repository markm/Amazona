//
//  Product.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/2/24.
//

import Foundation
import RealmSwift

class Product: Object, Decodable, Comparable {
    
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String = ""
    @Persisted var price: Double = 0
    @Persisted var descriptionText: String = ""
    @Persisted var category: String = ""
    @Persisted var imageURLString: String = ""
    @Persisted var rating: Rating?
    
    var imageURL: URL? { URL(string: imageURLString) }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case descriptionText = "description"
        case category
        case imageURLString = "image"
        case rating
    }
    
    // MARK: - Initializers
    
    convenience init(id: Int, 
                     title: String,
                     price: Double,
                     descriptionText: String,
                     category: String,
                     imageURLString: String,
                     rating: Rating?) {
        self.init()
        self.id = id
        self.title = title
        self.price = price
        self.descriptionText = descriptionText
        self.category = category
        self.imageURLString = imageURLString
        self.rating = rating
    }
}

/// Protocol conformances
extension Product {
    static func < (lhs: Product, rhs: Product) -> Bool { lhs.title < rhs.title }
}

// MARK: - Rating (EmbeddedObject)

class Rating: EmbeddedObject, Decodable, Comparable {
    @Persisted var rate: Double
    @Persisted var count: Int
    
    // MARK: - Initializers
    
    convenience init(rate: Double, count: Int) {
        self.init()
        self.rate = rate
        self.count = count
    }
    
    /// Protocol conformances
    static func < (lhs: Rating, rhs: Rating) -> Bool { lhs.rate < rhs.rate }
}

