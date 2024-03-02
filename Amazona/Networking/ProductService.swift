//
//  ProductService.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/2/24.
//

import Foundation
import Alamofire

class ProductService {

    @MainActor
    func fetchProducts() async throws -> [Product] {
        guard let url = Endpoint.products.url else {
            throw NetworkError.invalidURL
        }
        
        let products = try await AF.request(url).serializingDecodable([Product].self).value
        
        print("products: \(products)")
        
        return products
    }
}
