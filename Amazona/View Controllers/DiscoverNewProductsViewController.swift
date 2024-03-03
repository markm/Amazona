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

        view.addSubview(searchStackView)
        
        searchTextField.leftView = magnifyingGlassImageView
        searchStackView.addArrangedSubview(searchTextField)
        
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        searchStackView.addArrangedSubview(filterButton)
        searchStackView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Left(20),
            Right(20)
        )
        
        view.addSubview(titleView)
        titleView.easy.layout(
            Top(20).to(searchStackView, .bottom),
            Left(20),
            Right(20),
            Height(50)
        )
        
        let scrollView = createHorizontalScrollView()
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
        textField.easy.layout(
            Height(kTextFieldHeight)
        )
        return textField
    }()
    
    private let magnifyingGlassImageView: UIImageView = {
        let magnifyingGlassImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        magnifyingGlassImageView.contentMode = .center
        magnifyingGlassImageView.tintColor = .AmazonaGrey
        magnifyingGlassImageView.easy.layout(
            CenterY(),
            CenterX(),
            Width(40),
            Height(20)
        )
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
    
    private func createHorizontalScrollView() -> UIScrollView {
        // Create a UIScrollView
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true // Enable paging for horizontal scrolling
        scrollView.backgroundColor = .clear // Adjust as needed
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        
        // Add constraints to position the scroll view below the title view
        scrollView.easy.layout(
            Top().to(titleView, .bottom),
            Left(20),
            Right(20),
            Bottom(20)
        )
        
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
        stackView.easy.layout(Top(), Bottom(), Width().like(contentView))
        
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
        
        /// add the paging indicator
        view.addSubview(pageControl)
        
        // Add constraints to position the page control below the scroll view
        pageControl.easy.layout(
            Top().to(scrollView, .bottom),
            CenterX(),
            Bottom(20)
        )
        
        return scrollView
    }

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 5 // Set the number of pages
        pageControl.currentPage = 0 // Set the initial current page
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .darkGray
        return pageControl
    }()
}

extension DiscoverNewProductsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Calculate the current page based on the scroll view's content offset and width
        let currentPage = Int((scrollView.contentOffset.x + scrollView.bounds.width / 2) / scrollView.bounds.width)
        pageControl.currentPage = currentPage
    }
}

