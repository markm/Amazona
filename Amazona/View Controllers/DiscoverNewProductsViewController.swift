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
    private let products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// set up the search field and the filter button
        searchTextField.leftView = magnifyingGlassImageView
        magnifyingGlassImageView.easy.layout(
            CenterY(),
            CenterX(),
            Width(40),
            Height(40)
        )
        searchTextField.easy.layout(
            Height(kTextFieldHeight)
        )
        searchStackView.addArrangedSubview(searchTextField)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        searchStackView.addArrangedSubview(filterButton)
        view.addSubview(searchStackView)
        searchStackView.easy.layout(
            Top(8).to(view.safeAreaLayoutGuide, .top),
            Left(20),
            Right(20)
        )
        
        /// add the title view below it
        view.addSubview(titleView)
        titleView.easy.layout(
            Top(20).to(searchStackView, .bottom),
            Left(20),
            Right(20),
            Height(50)
        )
        
        /// set up the scroll view horizontal pager
        view.addSubview(scrollView)
        setupScrollView()
        
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
    
    private let searchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.layer.cornerRadius = kTextFieldHeight / 2
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.AmazonaGrey.cgColor
        textField.placeholder = "Search"
        textField.textAlignment = .left
        textField.leftViewMode = .always
        return textField
    }()
    
    private let magnifyingGlassImageView: UIImageView = {
        let magnifyingGlassImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        magnifyingGlassImageView.contentMode = .center
        magnifyingGlassImageView.tintColor = .AmazonaGrey
        return magnifyingGlassImageView
    }()
    
    private let filterButton: UIButton = {
        let filterButton = UIButton(type: .system)
        filterButton.tintColor = .AmazonaGrey
        filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle.fill"), for: .normal)
        return filterButton
    }()
    
    private let titleView: UITextView = {
        let titleView = UITextView()
        titleView.text = "Discover New Products"
        titleView.font = UIFont.systemFont(ofSize: 24)
        return titleView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true // Enable paging for horizontal scrolling
        scrollView.backgroundColor = .clear // Adjust as needed
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private func setupScrollView() {
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        // Create a contentView to hold the stack view inside the scroll view
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Add constraints to the contentView to match the size of the scrollView
        contentView.easy.layout(Edges(), Height().like(scrollView))
        
        // Create a UIStackView to hold the subviews horizontally
        contentView.addSubview(stackView)
        
        // Add constraints to make the stack view match the width of the content view
        stackView.easy.layout(Top(), Bottom(), Width().like(contentView))
        
        // Position the stack view within the content view
        stackView.easy.layout(Left(), Right(), CenterY().to(contentView))
        
        /*
        var previousCardView: UIView?
        for _ in 0..<5 {
            let productCardView = ProductCardView()
            productCardView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(productCardView)
            
            // Constrain product card's width
            productCardView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
            // Add spacing to the leading edge of the first card and trailing edge of the last card
            if let previousCardView = previousCardView {
                productCardView.leadingAnchor.constraint(equalTo: previousCardView.trailingAnchor, constant: 10).isActive = true
            }
            
            previousCardView = productCardView
        }
         */
        
        // Create and add subviews to the stack view
        for i in 0..<5 {
            let productCardView = ProductCardView()
            productCardView.backgroundColor = UIColor(red: CGFloat(i) * 0.2, green: 0.5, blue: 0.7, alpha: 1.0)
            productCardView.layer.cornerRadius = 20
            productCardView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(productCardView)
            
            // Add constraints for product card's size
            productCardView.easy.layout(
                Height().like(contentView),
                Width(-8).like(scrollView)
            )
        }
        
        /// add the paging indicator
        view.addSubview(pageControl)
        
        // Add constraints to position the scroll view below the title view
        scrollView.easy.layout(
            Top().to(titleView, .bottom),
            Left(20),
            Right(20),
            Bottom(60)
        )
        
        // Add constraints to position the page control below the scroll view
        pageControl.easy.layout(
            Top(8).to(scrollView, .bottom),
            CenterX(),
            Bottom(30)
        )
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 5 // Set the number of pages
        pageControl.currentPage = 0 // Set the initial current page
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .darkGray
        return pageControl
    }()
    
    private func addProductCards() {
        var previousCardView: UIView?

        // Assuming products is an array of product data
        for product in products {
            let productCardView = ProductCardView()
            productCardView.configure(with: product) // Configure product card with product data
            
            // Add product card view as subview
            scrollView.addSubview(productCardView)
            productCardView.translatesAutoresizingMaskIntoConstraints = false

            // Add constraints to position product card view horizontally
            NSLayoutConstraint.activate([
                productCardView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                productCardView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                productCardView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                productCardView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            ])

            if let previousCardView = previousCardView {
                // If there's a previous card, position the current card next to it
                productCardView.leadingAnchor.constraint(equalTo: previousCardView.trailingAnchor).isActive = true
            } else {
                // If this is the first card, position it at the leading edge of the scroll view
                productCardView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            }

            // Update the previous card view reference
            previousCardView = productCardView
        }

        // Add trailing constraint to the last card to ensure proper scrolling
        if let lastCardView = previousCardView {
            lastCardView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        }
    }
}

extension DiscoverNewProductsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// Calculate the current page based on the scroll view's content offset and width
        let currentPage = Int((scrollView.contentOffset.x + scrollView.bounds.width / 2) / scrollView.bounds.width)
        pageControl.currentPage = currentPage
    }
}

class ProductCardView: UIView {
    // Define UI elements for product card, e.g., image view, labels, etc.
    
    func configure(with product: Product) {
        // Use product data to update UI elements, e.g., set image, labels, etc.
        
        
    }
}

