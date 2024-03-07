//
//  ProductService.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/2/24.
//

import Foundation
import Alamofire

class ProductService: ProductServiceProtocol {

    @MainActor
    func fetchProducts() async throws -> [Product] {
        guard let url = Endpoint.products.url else {
            throw NetworkingError.invalidURL
        }
        var products = [Product]()
        let response = await AF.request(url).serializingDecodable([Product].self).response
        guard let statusCode = response.response?.statusCode else {
            throw NetworkingError.invalidResponse   /// no status code, invalid response
        }
        switch statusCode {
            case 200...299: /// Successful response, proceed with decoding the response body
                if let value = response.value {
                    products = value
                } else {
                    throw SerializationError.decodingFailed
                }
            case 401:
                throw NetworkError.unauthorized
            case 404:
                throw NetworkError.resourceNotFound
            default:
            throw NetworkError.unknown
        }
        return products
    }
}
