//
//  CategoryCell.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/6/24.
//

import Foundation
import UIKit
import EasyPeasy
import RxSwift


class CategoryCell: UICollectionViewCell {
    
    weak var delegate: CategoryCellDelegate?
    
    private var button: UIButton = UIButton(type: .system)
    private var category: Category?

    private var disposeBag = DisposeBag()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        layoutButton()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    func configure(with category: Category) {
        self.category = category
        button.setTitle(category.name, for: .normal)
        
        /// Force layout update, set corner radius, and update appearance to get the pill shape to take effect.
        self.contentView.layoutIfNeeded()
        self.button.layer.cornerRadius = self.button.bounds.height / 2
        self.button.layer.masksToBounds = true
        
        /// Update the button appearance based on the isSelected state of the category
        updateButtonAppearance(isSelected: category.isSelected.value)
        
        /// Subscribe to the isSelected state of the category
        category.isSelected.asObservable()
            .observe(on: MainScheduler.instance) /// Ensure UI updates are on the main thread
            .subscribe(onNext: { [weak self] isSelected in
                /// Update the button appearance based on the new isSelected state
                self?.updateButtonAppearance(isSelected: isSelected)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateButtonAppearance(isSelected: Bool) {
        if isSelected {
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.AmazonaMagenta.cgColor
            button.backgroundColor = .white
            button.setTitleColor(.AmazonaMagenta, for: .normal)
        } else {
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.AmazonaGrey.cgColor
            button.backgroundColor = .white
            button.setTitleColor(.AmazonaGrey, for: .normal)
        }
    }
    
    // MARK: - Layout

    private func layoutButton() {
        button.easy.layout(
            Edges()
        )
    }
    
    // MARK: - Actions

    @objc private func buttonTapped() {
        guard let category = category else { return }
        delegate?.categoryCell(self, didTapButtonFor: category)
    }
    
    // MARK: - Overrides
    
    override func prepareForReuse() {
        super.prepareForReuse()
        /// Dispose of any existing subscriptions, ensuring that each cell has only 1 active subscription at a time
        disposeBag = DisposeBag()
        updateButtonAppearance(isSelected: false) /// Reset to default appearance
    }
}


