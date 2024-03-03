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

        let stackView = getSearchStackView()
        view.addSubview(stackView)

        let textField = createSearchTextField()
        textField.easy.layout(
            Height(kTextFieldHeight)
        )
        
        let magnifyingGlassImageView = createMagnifyingGlassImageView()
        magnifyingGlassImageView.easy.layout(
            CenterY(),
            CenterX(),
            Width(40),
            Height(20)
        )
        
        textField.leftView = magnifyingGlassImageView
        textField.leftViewMode = .always
        stackView.addArrangedSubview(textField)
        
        let filterButton = createFilterButton()
        stackView.addArrangedSubview(filterButton)
        stackView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Left(20),
            Right(20)
        )
        
        let titleView = createTitleView()
        view.addSubview(titleView)
        titleView.easy.layout(
            Top(20).to(stackView, .bottom),
            Left(20),
            Right(20),
            Height(60)
        )
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
    
    private func getSearchStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }
    
    private func createSearchTextField() -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.layer.cornerRadius = kTextFieldHeight / 2
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.AmazonaGrey.cgColor
        textField.placeholder = "Search"
        textField.textAlignment = .left
        return textField
    }
    
    private func createMagnifyingGlassImageView() -> UIImageView {
        let magnifyingGlassImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        magnifyingGlassImageView.contentMode = .center
        magnifyingGlassImageView.tintColor = .AmazonaGrey
        return magnifyingGlassImageView
    }
    
    private func createFilterButton() -> UIButton {
        let filterButton = UIButton(type: .system)
        filterButton.tintColor = .AmazonaGrey
        filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle.fill"), for: .normal)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return filterButton
    }
    
    private func createTitleView() -> UITextView {
        let titleView = UITextView()
        titleView.text = "Discover New Products"
        titleView.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(titleView)
        return titleView
    }
}
