//
//  ProductCardView.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/4/24.
//

import UIKit
import EasyPeasy

class ProductCardView: UIView {
    
    init(product: Product) {
        super.init(frame: .zero)
        addViews()
        configureCardBorder()
        layoutViews()
        configure(with: product)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(productImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(ratingStackView)
        
        bottomStackView.addArrangedSubview(categoryContainerView)
        bottomStackView.addArrangedSubview(priceLabel)
        ratingStackView.addArrangedSubview(ratingStarImageView)
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.addArrangedSubview(ratingCountLabel)
        
        addSubview(bottomStackView)
        categoryContainerView.addSubview(categoryLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        /// Since bounds are now correctly set, update the path of the shadow layer
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: layer.cornerRadius).cgPath
    }
    
    private func configureCardBorder() {
        /// set common properties that don't depend on the layout here
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 5
        layer.cornerRadius = kCornerRadius
        layer.masksToBounds = false /// Important for shadows
    }
    
    private func layoutViews() {
        productImageView.easy.layout(
            Top(kMediumPadding),
            Leading(kMediumPadding),
            Trailing(kMediumPadding),
            Height(*0.55).like(self)
        )
        
        titleLabel.easy.layout(
            Top(kMediumPadding).to(productImageView, .bottom),
            Leading(kMediumPadding),
            Trailing(kMediumPadding)
        )
        
        descriptionLabel.easy.layout(
            Top(kSmallPadding).to(titleLabel, .bottom),
            Leading(kMediumPadding),
            Trailing(kMediumPadding)
        )
        
        ratingStackView.easy.layout(
            Top(kSmallPadding).to(descriptionLabel, .bottom),
            Leading(kMediumPadding)
        )
        
        bottomStackView.easy.layout(
            Bottom(kSmallPadding).to(safeAreaLayoutGuide, .bottom),
            Leading(kSmallPadding),
            Trailing(kSmallPadding)
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
    }
    
    private func configure(with product: Product) {
        titleLabel.text = product.title
        priceLabel.text = "\(product.price.formatted(.currency(code: "EUR")))"
        descriptionLabel.text = product.descriptionText
        ratingLabel.text = "\(product.rating?.rate ?? 0)"
        ratingCountLabel.text = "(\(product.rating?.count ?? 0) ratings)"
        categoryLabel.text = product.category
        /// Load image from URL
        if let imageURL = URL(string: product.imageURLString) {
            URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.productImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
    
    // MARK: - Views
    
    private let productImageView: UIImageView = {
        let productImageView = UIImageView()
        productImageView.contentMode = .scaleAspectFit
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = kCornerRadius
        productImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return productImageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font =  AppFonts.helveticaNeue(ofSize: 18, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        return titleLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = AppFonts.helveticaNeue(ofSize: 14)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 2
        descriptionLabel.lineBreakMode = .byWordWrapping
        return descriptionLabel
    }()
    
    private let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = AppFonts.helveticaNeue(ofSize: 24, weight: .bold)
        priceLabel.textColor = .black
        priceLabel.textAlignment = .right
        return priceLabel
    }()
    
    private let ratingLabel: UILabel = {
        let ratingLabel = UILabel()
        ratingLabel.font = AppFonts.helveticaNeue(ofSize: 16)
        ratingLabel.textColor = .black
        return ratingLabel
    }()
    
    private let ratingCountLabel: UILabel = {
        let ratingLabel = UILabel()
        ratingLabel.font = AppFonts.helveticaNeue(ofSize: 16)
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
        imageView.layer.cornerRadius = kCornerRadius
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .AmazonaDeepYellow
        return imageView
    }()
    
    private let categoryLabel: UILabel = {
       let categoryLabel = UILabel()
        categoryLabel.textColor = .white
        categoryLabel.font = AppFonts.helveticaNeue(ofSize: 16)
        categoryLabel.textAlignment = .center
        return categoryLabel
    }()
    
    private let categoryContainerView: UIView = {
        let categoryContainerView = UIView()
        categoryContainerView.backgroundColor = .AmazonaMagenta
        categoryContainerView.layer.cornerRadius = 14
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
}

