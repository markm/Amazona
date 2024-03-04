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
        layoutViews()
        configure(with: product)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(ratingLabel)
        addSubview(freeTagView)
        addSubview(priceLabel)
        freeTagView.addSubview(freeTagLabel)
    }
    
    private func layoutViews() {
        imageView.easy.layout(
            Top(),
            Leading(),
            Trailing(),
            Height(*0.5).like(self)
        )
        
        titleLabel.easy.layout(
            Top(16).to(imageView, .bottom),
            Leading(10),
            Trailing(10)
        )
        
        subtitleLabel.easy.layout(
            Top(8).to(titleLabel, .bottom),
            Leading(10),
            Trailing(10)
        )
        
        ratingLabel.easy.layout(
            Top(8).to(subtitleLabel, .bottom),
            Leading(10)
        )
        
        freeTagView.easy.layout(
            Leading(10),
            Bottom(10),
            Width(50),
            Height(20)
        )
        
        freeTagLabel.easy.layout(
            Center()
        )
        
        priceLabel.easy.layout(
            Bottom(10),
            Trailing(10)
        )
    }
    
    private func configure(with product: Product) {
        titleLabel.text = product.title
        priceLabel.text = "Price: $\(product.price)"
        subtitleLabel.text = product.descriptionText
        ratingLabel.text = "Rating: \(product.rating?.rate ?? 0)"
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
        imageView.layer.cornerRadius = 8
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
        subtitleLabel.numberOfLines = 3
        subtitleLabel.lineBreakMode = .byWordWrapping
        return subtitleLabel
    }()
    
    private let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = AppFonts.helveticaNeue(ofSize: 16, weight: .bold)
        priceLabel.textColor = .red
        return priceLabel
    }()
    
    private let ratingLabel: UILabel = {
        let ratingLabel = UILabel()
        ratingLabel.font = AppFonts.helveticaNeue(ofSize: 14)
        ratingLabel.textColor = .black
        return ratingLabel
    }()
    
    private let freeTagLabel: UILabel = {
       let freeTagLabel = UILabel()
        freeTagLabel.text = "Free"
        freeTagLabel.textColor = .white
        freeTagLabel.font = AppFonts.helveticaNeue(ofSize: 12)
        freeTagLabel.textAlignment = .center
        return freeTagLabel
    }()
    
    private let freeTagView: UIView = {
        let freeTagView = UIView()
        freeTagView.backgroundColor = .green
        freeTagView.layer.cornerRadius = 8
        return freeTagView
    }()
}

