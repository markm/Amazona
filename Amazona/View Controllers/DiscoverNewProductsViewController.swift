//
//  DiscoverNewProductsViewController.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/2/24.
//

import UIKit
import RxSwift

class DiscoverNewProductsViewController: UIViewController {
    
    private let viewModel = DiscoverNewProductsViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            do {
                let products = try await viewModel.fetchProducts()
                print("products: \(products)")
            } catch {
                print("Error: \(error)")
                showErrorAlert(error)
            }
        }
    }

    // Function to display an alert with the error message
    func showErrorAlert(_ error: Error) {
        let alertController = UIAlertController(title: "Error", 
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
