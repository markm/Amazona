//
//  DiscoverNewProductsViewController.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/2/24.
//

import UIKit
import RxSwift

class DiscoverNewProductsViewController: UIViewController {
    
    private let productService = ProductService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            do {
                let products = try await productService.fetchProducts()
                print("products: \(products)")
            } catch {
                print("Error: \(error)")
            }
        }
    }


}
