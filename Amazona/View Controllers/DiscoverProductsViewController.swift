//
//  DiscoverProductsViewController.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/4/24.
//

import UIKit
import RxSwift
import RxCocoa
import EasyPeasy

class DiscoverProductsViewController: UIViewController {
    
    let viewModel: ProductsViewModel
    
    private var products: [Product] = []
    private var cardWidth: CGFloat = 0 /// Card width will be set based on the scrollView's width
    private let disposeBag = DisposeBag()

    /// UI Components
    private let filterButton = UIButton()
    private let searchTextField = UITextField()
    private let horizontalScrollView = UIScrollView()
    
    private let searchStackView: UIStackView = {
        let searchStackView = UIStackView()
        searchStackView.axis = .horizontal
        searchStackView.spacing = kSmallPadding
        searchStackView.distribution = .fill
        searchStackView.alignment = .center
        return searchStackView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .AmazonaDarkBlue
        pageControl.currentPageIndicatorTintColor = .AmazonaMagenta
        return pageControl
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = kDiscoverNewProductsTitle
        titleLabel.textColor = .black
        titleLabel.font = AppFonts.helveticaNeue(ofSize: kTitleFontSize, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        return titleLabel
    }()
    
    private let magnifyingGlassImageView: UIImageView = {
       let magnifyingGlassImageView = UIImageView()
        magnifyingGlassImageView.image = AppImages.magnifyingGlass
        magnifyingGlassImageView.contentMode = .center
        magnifyingGlassImageView.tintColor = .AmazonaGrey
        return magnifyingGlassImageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .AmazonaMagenta
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    // MARK: - Initializers
    
    init(viewModel: ProductsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(kInitNotImplementedErrorMessage)
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layoutViews()
        configureScrollView()
        bindToProducts()
        bindToSelectedCategories()
        bindToSelectedSortOption()
        fetchProducts()
        title = kDiscoverNewProductsTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Networking

    @MainActor
    private func fetchProducts() {
        activityIndicator.startAnimating()
        Task {
            do {
                try await viewModel.fetchProducts()
                self.activityIndicator.stopAnimating()
            } catch {
                print("ERROR: fetching products: \(error.localizedDescription)")
                showErrorAlert(error)
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - Setup Methods for UI Elements
    
    private func setupViews() {
        setupHorizontalScrollView()
        setupFilterButton()
        setupSearchTextField()
        
        /// Put the search text field and the filter button in a stack view, then add it the view
        searchTextField.leftView = magnifyingGlassImageView
        searchStackView.addArrangedSubview(searchTextField)
        searchStackView.addArrangedSubview(filterButton)
        
        view.addSubview(horizontalScrollView)
        view.addSubview(searchStackView)
        view.addSubview(horizontalScrollView)
        view.addSubview(titleLabel)
        view.addSubview(pageControl)
        view.addSubview(activityIndicator)
    }
    
    private func setupFilterButton() {
        filterButton.tintColor = .AmazonaGrey
        filterButton.setBackgroundImage(AppImages.filter?.withRenderingMode(.alwaysTemplate), for: .normal)
        filterButton.addTarget(self, action: #selector(presentFilterProductsViewController), for: .touchUpInside)
        filterButton.imageView?.contentMode = .scaleAspectFit
    }
    
    private func setupSearchTextField() {
        searchTextField.layer.cornerRadius = kSearchTextFieldHeight / 2
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.AmazonaGrey.cgColor
        searchTextField.placeholder = kSearchTextFieldPlaceholder
        searchTextField.textAlignment = .left
        searchTextField.leftViewMode = .always
        searchTextField.delegate = self
        searchTextField.accessibilityIdentifier = kSearchTextFieldIdentifier /// for UI testing
        addDoneButtonToSearchKeyboard()
    }
    
    private func setupHorizontalScrollView() {
        horizontalScrollView.delegate = self
        horizontalScrollView.isPagingEnabled = true
        horizontalScrollView.showsHorizontalScrollIndicator = false
    }
    
    // MARK: - Layout Methods for UI Elements
    
    private func layoutViews() {
        searchStackView.easy.layout(
            Top(kMediumPadding).to(view.safeAreaLayoutGuide, .top),
            Leading(kMediumPadding),
            Trailing(kMediumPadding)
        )
        searchTextField.easy.layout(
            Height(kSearchTextFieldHeight)
        )
        magnifyingGlassImageView.easy.layout(
            Width(kSmallSquareSize),
            Height(kSmallSquareSize)
        )
        filterButton.easy.layout(
            Width(kSearchTextFieldHeight),
            Height(kSearchTextFieldHeight)
        )
        titleLabel.easy.layout(
            Top(kMediumPadding).to(searchStackView, .bottom),
            Leading(kMediumPadding),
            Trailing(kMediumPadding),
            Height(kTitleHeight)
        )
        horizontalScrollView.easy.layout(
            Top(kSmallPadding).to(titleLabel, .bottom),
            Leading(),
            Trailing()
        )
        pageControl.easy.layout(
            Top(kSmallPadding).to(horizontalScrollView, .bottom),
            CenterX(),
            Height(kSmallSquareSize),
            Bottom(kSmallPadding).to(view.safeAreaLayoutGuide, .bottom)
        )
        activityIndicator.easy.layout(
            Center()
        )
    }
    
    private func layoutProductCards() {
        resetHorizontalScrollView()
        
        let cardHeight = horizontalScrollView.frame.height - 20
        let pageWidth = view.bounds.width
        var xOffset: CGFloat = 0

        for (index, product) in products.enumerated() {
            let productCardView = ProductCardView(product: product)
            
            /// Calculate the horizontal center for the card within the pageWidth
            let cardXCenter = xOffset + (pageWidth - cardWidth) / 2
            
            /// Set the frame for the card view
            productCardView.frame = CGRect(x: cardXCenter,
                                           y: kSmallPadding,
                                           width: cardWidth,
                                           height: cardHeight)
            horizontalScrollView.addSubview(productCardView)

            /// Increment xOffset for the next page
            xOffset += pageWidth

            /// Additional setup for productCardView...
            productCardView.layer.cornerRadius = kDefaultCornerRadius
            productCardView.contentMode = .scaleAspectFit
            productCardView.isUserInteractionEnabled = true
            let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                              action: #selector(self.productCardTapped(_:)))
            productCardView.addGestureRecognizer(tapGestureRecognizer)
            productCardView.tag = index /// used upon selection
        }

        /// The contentSize width is the xOffset after all cards have been laid out
        horizontalScrollView.contentSize = CGSize(width: xOffset, height: cardHeight)
    }
    
    private func configureScrollView() {
        cardWidth = view.frame.width * 0.8 /// cards take up 80% of the view's width
        let sidePadding = (view.frame.width - cardWidth) / 2
        horizontalScrollView.contentInset = UIEdgeInsets(top: 0, left: sidePadding, bottom: 0, right: sidePadding)
    }
    
    // MARK: - Actions
    
    @objc private func presentFilterProductsViewController() {        
        let filterProductsViewController = FilterProductsViewController(viewModel: viewModel)
        if #available(iOS 13.0, *) {
            filterProductsViewController.modalPresentationStyle = .pageSheet
            filterProductsViewController.isModalInPresentation = false /// allows swipe down to dismiss
        } else {
            filterProductsViewController.modalPresentationStyle = .fullScreen /// Fallback on earlier versions
        }
        present(filterProductsViewController, animated: true, completion: nil)
    }
    
    @objc private func productCardTapped(_ recognizer: UITapGestureRecognizer) {
        guard let cardView = recognizer.view else { return }
        let productIndex = cardView.tag
        let product = products[productIndex]
        let productViewController = ProductDetailViewController(product: product)
        navigationController?.pushViewController(productViewController, animated: true)
    }
    
    @objc private func doneButtonAction() {
        searchTextField.resignFirstResponder()
    }
    
    // MARK: - Helpers
    
    private func addDoneButtonToSearchKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0,
                                                                  y: 0,
                                                                  width: UIScreen.main.bounds.width,
                                                                  height: kToolbarHeight))
        /// Customize the toolbar appearance
        doneToolbar.barStyle = .default
        doneToolbar.barTintColor = UIColor.darkGray /// background color
        doneToolbar.tintColor = UIColor.white /// button color
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton: UIBarButtonItem = UIBarButtonItem(title: kDoneTitle,
                                                             style: .done,
                                                             target: self,
                                                             action: #selector(self.doneButtonAction))
        /// Set custom font and color for the "Done" button
        let attributes: [NSAttributedString.Key: Any] = [
            .font: AppFonts.helveticaNeue(ofSize: kRegularFontSize),
            .foregroundColor: UIColor.white
        ]
        doneBarButton.setTitleTextAttributes(attributes, for: .normal)
        doneBarButton.setTitleTextAttributes(attributes, for: .highlighted)
        let items = [flexSpace, doneBarButton]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        searchTextField.inputAccessoryView = doneToolbar
    }
    
    private func resetHorizontalScrollView() {
        horizontalScrollView.subviews.forEach { $0.removeFromSuperview() }
        horizontalScrollView.contentOffset = CGPoint.zero
    }
    
    private func bindToProducts() {
        viewModel.products
            .observe(on: MainScheduler.instance) /// ensure UI updates are performed on the main thread.
            .subscribe(onNext: { [weak self] products in
                self?.products = products
                self?.configureScrollView()
                self?.layoutProductCards()
                self?.pageControl.numberOfPages = products.count
            })
            .disposed(by: disposeBag)
    }
    
    private func bindToSelectedCategories() {
        /**
         Observe the selected categories from the view model, and filter the products accordingly
         */
        viewModel.selectedCategories
            .observe(on: MainScheduler.instance) /// ensure UI updates are performed on the main thread.
            .subscribe(onNext: { [weak self] selectedCategories in
                guard let self else { return }
                /**
                 Filter the original products based on the selected categories
                 */
                self.products = self.viewModel.originalProducts.filter {
                    selectedCategories.map { $0.name }.contains($0.category)
                }
                viewModel.updateProducts(with: self.products)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindToSelectedSortOption() {
        /**
         Observe the selected sort option from the view model, and sort the products accordingly
         */
        viewModel.selectedSortOption
            .observe(on: MainScheduler.instance) /// ensure UI updates are performed on the main thread.
            .subscribe(onNext: { [weak self] selectedSortOption in
                guard let self, let selectedSortOption else { return }
                
                /// Sort the products based on the selected sort option and publish the sorted products
                viewModel.sortProducts(products, withSortOption: selectedSortOption)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UIScrollViewDelegate

extension DiscoverProductsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = view.bounds.width /// Use the full width of the view as the page width
        let fractionalPage = scrollView.contentOffset.x / pageWidth
        let page = lround(Double(fractionalPage)) /// Round to the nearest whole number to get the current page
        pageControl.currentPage = page
    }
}

// MARK: - UITextFieldDelegate

extension DiscoverProductsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

