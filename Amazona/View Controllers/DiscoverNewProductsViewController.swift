//
//  DiscoverNewProductsViewController.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/2/24.
//

import UIKit
import RxSwift
import EasyPeasy

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

        /// create a horizontal stack view
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        view.addSubview(stackView)

        /// create a UITextField
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.layer.cornerRadius = kTextFieldHeight / 2
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.AmazonaGrey.cgColor
        textField.placeholder = "Search"
        textField.textAlignment = .left
        textField.easy.layout(
            Height(kTextFieldHeight)
        )
        
        /// create the magnifying class image
        let magnifyingGlassImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        magnifyingGlassImageView.contentMode = .center
        magnifyingGlassImageView.tintColor = .AmazonaGrey
        magnifyingGlassImageView.easy.layout(
            CenterY(),
            CenterX(),
            Width(40),
            Height(20)
        )
        
        textField.leftView = magnifyingGlassImageView
        textField.leftViewMode = .always
        stackView.addArrangedSubview(textField)
        
        /// create the filter button
        let filterButton = UIButton(type: .system)
        filterButton.tintColor = .AmazonaGrey
        filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle.fill"), for: .normal)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        stackView.addArrangedSubview(filterButton)
        stackView.easy.layout(
            Top(50),
            Left(20),
            Right(20)
        )
    }
    
    @objc private func filterButtonTapped() {
        // Handle filter button tap
    }

    // Function to display an alert with the error message
    private func showErrorAlert(_ error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
