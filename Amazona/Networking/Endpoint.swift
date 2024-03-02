//
//  Endpoint.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/2/24.
//

import Foundation

enum Endpoint {
    case products
}

extension Endpoint {
    
    enum Method {
        case GET
        case POST(data: Data?)
    }
}

extension Endpoint {
    
    private var host: String { "fakestoreapi.com" } // https://fakestoreapi.com/products/
    
    private var path: String {
        switch self {
        case .products:
            return "/products"
        }
    }
    
    private var method: Method {
        switch self {
        case .products:
            return .GET
        }
    }
}

extension Endpoint {
    
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        return urlComponents.url
    }
}
