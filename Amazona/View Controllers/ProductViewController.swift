//
//  ProductViewController.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/4/24.
//

import UIKit
import EasyPeasy

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
        
        navigationController?.title = product.title
        
        let label = UILabel()
        label.text = product.title
        view.addSubview(label)
        label.easy.layout(
            CenterX(),
            CenterY()
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
