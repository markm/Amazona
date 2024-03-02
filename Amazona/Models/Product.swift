//
//  Product.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/2/24.
//

import Foundation
import RealmSwift

class Product: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String = ""
    @Persisted var price: Double = 0
    @Persisted var descriptionText: String = ""
    @Persisted var category: String = ""
    @Persisted var imageURLString: String = ""
    @Persisted var rating: Rating?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case descriptionText = "description"
        case category
        case imageURLString = "image"
        case rating
    }
}

class Rating: EmbeddedObject, Decodable {
    @Persisted var rate: Double
    @Persisted var count: Int
}

