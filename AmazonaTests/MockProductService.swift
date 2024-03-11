//
//  MockProductService.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/7/24.
//

import Foundation
@testable import Amazona

class MockProductService: ProductServiceProtocol {
    
    var expectedProducts: [Product] = []
    var fetchProductsShouldFail: Bool = false
    
    var mockProducts: [Product] {
        [BurtsBeesLipGloss, YamahaSpeakers, MacbookPro, PassportHolder, RaybanSunglasses]
    }
    
    func fetchProducts() async throws -> [Product] {
        if fetchProductsShouldFail {
            throw NSError(domain: "com.example", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock fetch products failed"])
        }
        return [RaybanSunglasses, PassportHolder]
    }
}


