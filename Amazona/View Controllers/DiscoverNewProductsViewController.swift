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

    // MARK: - Lifecycle
    
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
        view.addSubview(titleLabel)
        titleLabel.easy.layout(
            Top(20).to(searchStackView, .bottom),
            Leading(20),
            Trailing(20),
            Height(60)
        )
        
        /// set up the scroll view horizontal pager
        view.addSubview(scrollView)
        setupScrollView()
        
        /// Convert async operation to Observable
        let observable = Observable<[Product]>.create { observer in
            Task {
                do {
                    let products = try await self.viewModel.fetchProducts()
                    observer.onNext(products)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }

        /// Subscribe to the observable
        observable
            .subscribe(onNext: { products in
                print("Products: \(products)")
                /// React to the products here
                
                self.pageControl.numberOfPages = products.count /// Set the number of pages
                
                for product in products {
                    let productCardView = ProductCardView(product: product)
                    productCardView.layer.cornerRadius = 20
                    productCardView.contentMode = .scaleAspectFit
                    self.stackView.addArrangedSubview(productCardView)
                    productCardView.easy.layout(
                        Height().like(self.contentView),
                        Width(-8).like(self.scrollView)
                    )
                }
            }, onError: { error in
                print("Error: \(error)")
                self.showErrorAlert(error)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Views
    
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
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Discover New Products"
        titleLabel.textColor = .black
        titleLabel.font = AppFonts.helveticaNeue(ofSize: 26)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        return titleLabel
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true // Enable paging for horizontal scrolling
        scrollView.backgroundColor = .clear // Adjust as needed
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
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
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .darkGray
        return pageControl
    }()
    
    // MARK: - Actions & Helpers
    
    @objc private func filterButtonTapped() {
        // Handle filter button tap
    }

    private func showErrorAlert(_ error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        contentView.easy.layout(
            Edges(),
            Height().like(scrollView)
        )
        stackView.easy.layout(
            Top(),
            Bottom(),
            Width().like(contentView)
        )
        stackView.easy.layout(
            Left(),
            Right(),
            CenterY().to(contentView)
        )
        
        view.addSubview(pageControl)
        
        scrollView.easy.layout(
            Top(20).to(titleLabel, .bottom),
            Left(20),
            Right(20),
            Bottom(60)
        )
        pageControl.easy.layout(
            Top(8).to(scrollView, .bottom),
            CenterX(),
            Bottom(30)
        )
    }
}

extension DiscoverNewProductsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }
}

