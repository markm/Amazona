//
//  ProductDetailViewController.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/4/24.
//

import UIKit
import EasyPeasy
import Kingfisher

class ProductDetailViewController: UIViewController {
    
    var product: Product
    
    private lazy var scrollView: UIScrollView = {
         let scrollView = UIScrollView()
         scrollView.showsVerticalScrollIndicator = true
         return scrollView
     }()
     
     private let contentView: UIView = {
         let view = UIView()
         return view
     }()
    
    private let productImageView: UIImageView = {
        let productImageView = UIImageView()
        productImageView.contentMode = .scaleAspectFit
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = kDefaultCornerRadius
        productImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return productImageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = AppFonts.helveticaNeue(ofSize: kMediumFontSize, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        return titleLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = AppFonts.helveticaNeue(ofSize: kSmallFontSize)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        return descriptionLabel
    }()
    
    private let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = AppFonts.helveticaNeue(ofSize: kLargeFontSize, weight: .bold)
        priceLabel.textColor = .black
        priceLabel.textAlignment = .right
        return priceLabel
    }()
    
    private let ratingLabel: UILabel = {
        let ratingLabel = UILabel()
        ratingLabel.font = AppFonts.helveticaNeue(ofSize: kRegularFontSize)
        ratingLabel.textColor = .black
        return ratingLabel
    }()
    
    private let ratingCountLabel: UILabel = {
        let ratingLabel = UILabel()
        ratingLabel.font = AppFonts.helveticaNeue(ofSize: kRegularFontSize)
        ratingLabel.textColor = .gray
        return ratingLabel
    }()
    
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = kSmallPadding
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private let ratingStarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = kDefaultCornerRadius
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.image = AppImages.starFilled
        imageView.tintColor = .AmazonaDeepYellow
        return imageView
    }()
    
    private let categoryLabel: UILabel = {
       let categoryLabel = UILabel()
        categoryLabel.textColor = .white
        categoryLabel.font = AppFonts.helveticaNeue(ofSize: kRegularFontSize)
        categoryLabel.textAlignment = .center
        return categoryLabel
    }()
    
    private let categoryContainerView: UIView = {
        let categoryContainerView = UIView()
        categoryContainerView.backgroundColor = .AmazonaMagenta
        categoryContainerView.layer.cornerRadius = kDefaultCornerRadius
        categoryContainerView.clipsToBounds = true
        return categoryContainerView
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = kSmallPadding
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private let buyNowButton: UIButton = {
        let button = UIButton()
        button.setTitle(kBuyNowTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = AppFonts.helveticaNeue(ofSize: kMediumFontSize, weight: .bold)
        button.backgroundColor = UIColor.AmazonaVibrantGreen
        button.layer.cornerRadius = kBuyNowCornerRadius
        /// apply shadow
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: kShadowHeight)
        button.layer.shadowRadius = kShadowRadius
        button.layer.shadowOpacity = kShadowOpacity
        button.layer.masksToBounds = false
        /// enable autolayout - using easy peasy library
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializers
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(kInitNotImplementedErrorMessage)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        layoutViews()
        configureProduct()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup Methods for UI Elements
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(ratingStackView)
        contentView.addSubview(buyNowButton)

        ratingStackView.addArrangedSubview(ratingStarImageView)
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.addArrangedSubview(ratingCountLabel)

        contentView.addSubview(bottomStackView)
        bottomStackView.addArrangedSubview(categoryContainerView)
        bottomStackView.addArrangedSubview(priceLabel)

        categoryContainerView.addSubview(categoryLabel)

        buyNowButton.addTarget(self, action: #selector(buyNowWasSelected), for: .touchUpInside)
    }
    
    // MARK: - Layout Methods for UI Elements
    
    private func layoutViews() {
        scrollView.easy.layout(
            Edges(),
            Width().like(view)
        )
        contentView.easy.layout(
            Edges(),
            Width().like(scrollView)
        )
        productImageView.easy.layout(
            Top(kMediumPadding).to(contentView.safeAreaLayoutGuide, .top),
            CenterX(),
            Height(*0.45).like(view, .height), // relate to view's height instead of contentView's safeAreaLayoutGuide
            Leading(kMediumPadding).to(contentView.safeAreaLayoutGuide, .leading),
            Trailing(kMediumPadding).to(contentView.safeAreaLayoutGuide, .trailing)
        )
        titleLabel.easy.layout(
            Top(kMediumPadding).to(productImageView, .bottom),
            CenterX(),
            Leading(kMediumPadding).to(contentView.safeAreaLayoutGuide, .leading),
            Trailing(kMediumPadding).to(contentView.safeAreaLayoutGuide, .trailing)
        )
        descriptionLabel.easy.layout(
            Top(kSmallPadding).to(titleLabel, .bottom),
            CenterX(),
            Leading(kMediumPadding).to(contentView.safeAreaLayoutGuide, .leading),
            Trailing(kMediumPadding).to(contentView.safeAreaLayoutGuide, .trailing)
        )
        ratingStackView.easy.layout(
            Top(kSmallPadding).to(descriptionLabel, .bottom),
            Leading(kMediumPadding)
        )
        bottomStackView.easy.layout(
            Leading(kMediumPadding),
            Trailing(kMediumPadding),
            Top(kMediumPadding).to(ratingStackView, .bottom)
        )
        categoryContainerView.easy.layout(
            Height().like(bottomStackView),
            Width(*0.5).like(bottomStackView)
        )
        categoryLabel.easy.layout(
            Center()
        )
        priceLabel.easy.layout(
            Height().like(bottomStackView)
        )
        buyNowButton.easy.layout(
            Top(kMediumPadding).to(bottomStackView, .bottom),
            Leading(kMediumPadding),
            Trailing(kMediumPadding),
            Height(kBuyNowButtonHeight),
            Bottom(kMediumPadding).to(contentView, .bottom) // This is crucial
        )
    }
    
    // MARK: Configuration Methods for UI Elements
    
    @MainActor
    private func configureProduct() {
        titleLabel.text = product.title
        priceLabel.text = "\(product.price.formatted(.currency(code: kEuroCurrencyCode)))"
        descriptionLabel.text = product.descriptionText
        ratingLabel.text = "\(product.rating?.rate ?? 0)"
        ratingCountLabel.text = "(\(product.rating?.count ?? 0) ratings)"
        categoryLabel.text = product.category
        productImageView.setImage(withURL: product.imageURL) { [weak self] error in
            if let error {
                self?.showErrorAlert(error)
            }
        }
    }

    // MARK: - Actions

    @objc private func buyNowWasSelected() {
        print("Buy Now was selected")
    }
}
