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
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(ratingLabel)
        
        bottomStackView.addArrangedSubview(categoryContainerView)
        bottomStackView.addArrangedSubview(priceLabel)
        
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
        layer.masksToBounds = false // Important for shadows
    }
    
    private func layoutViews() {
        imageView.easy.layout(
            Top(kMediumPadding),
            Leading(kMediumPadding),
            Trailing(kMediumPadding),
            Height(*0.55).like(self)
        )
        
        titleLabel.easy.layout(
            Top(kMediumPadding).to(imageView, .bottom),
            Leading(kMediumPadding),
            Trailing(kMediumPadding)
        )
        
        subtitleLabel.easy.layout(
            Top(kSmallPadding).to(titleLabel, .bottom),
            Leading(kMediumPadding),
            Trailing(kMediumPadding)
        )
        
        ratingLabel.easy.layout(
            Top(kSmallPadding).to(subtitleLabel, .bottom),
            Leading(kMediumPadding)
        )
        
        bottomStackView.easy.layout(
            Bottom(kSmallPadding).to(safeAreaLayoutGuide, .bottom),
            Leading(kSmallPadding),
            Trailing(kMediumPadding)
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
        subtitleLabel.text = product.descriptionText
        ratingLabel.text = "Rating: \(product.rating?.rate ?? 0)"
        categoryLabel.text = product.category
        /// Load image from URL
        if let imageURL = URL(string: product.imageURLString) {
            URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
    
    // MARK: - Views
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = kCornerRadius
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font =  AppFonts.helveticaNeue(ofSize: 18, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        return titleLabel
    }()
    
    private let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.font = AppFonts.helveticaNeue(ofSize: 14)
        subtitleLabel.textColor = .darkGray
        subtitleLabel.numberOfLines = 2
        subtitleLabel.lineBreakMode = .byWordWrapping
        return subtitleLabel
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

