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
            Height(50)
        )
        
        let scrollView = createHorizontalScrollView()
        scrollView.backgroundColor = .purple
        view.addSubview(scrollView)
        scrollView.easy.layout(
            Top().to(titleView, .bottom),
            Left(20),
            Right(20),
            Bottom(20)
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
    
    private func createHorizontalScrollView() -> UIScrollView {
        super.viewDidLoad()

        // Create a UIScrollView
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true // Enable paging for horizontal scrolling
        view.addSubview(scrollView)
        
        // Add constraints to make the scroll view fill the entire view
        scrollView.easy.layout(Edges())
        
        // Create a contentView to hold the stack view inside the scroll view
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Add constraints to the contentView to match the size of the scrollView
        contentView.easy.layout(Edges(), Height().like(scrollView))
        
        // Create a UIStackView to hold the subviews horizontally
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        contentView.addSubview(stackView)
        
        // Add constraints to make the stack view match the width of the content view
        stackView.easy.layout(Top(), Bottom(), Width(*5)) // Adjust multiplier according to the number of subviews
        
        // Position the stack view within the content view
        stackView.easy.layout(Left(), Right())
        
        // Create and add subviews to the stack view
        for i in 0..<5 {
            let subview = UIView()
            subview.backgroundColor = UIColor(red: CGFloat(i) * 0.2, green: 0.5, blue: 0.7, alpha: 1.0)
            stackView.addArrangedSubview(subview)
            
            // Add constraints for subview's size
            subview.easy.layout(Height().like(contentView), Width().like(scrollView))
        }
        return scrollView
    }
}
