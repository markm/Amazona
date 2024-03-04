//
//  ProductViewController.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/4/24.
//

import Foundation
import UIKit

class ProductViewController: UIViewController {
    
    var product: Product
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
