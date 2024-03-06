//
//  FilterProductsViewController.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/5/24.
//

import UIKit
import RxSwift
import EasyPeasy

class FilterProductsViewController: UIViewController {
    
    var priceRangeSubject = BehaviorSubject<ClosedRange<Double>?>(value: nil)
    var selectedCategorySubject = BehaviorSubject<String?>(value: nil)
    var selectedRatingSubject = BehaviorSubject<Int?>(value: nil)
    
    private let doneButton = UIButton()
    private let resetButton = UIButton()
    private var selectedPriceRange: ClosedRange<Double> = 0.0...100.0
    private let disposeBag = DisposeBag()
    
    private let topStackView: UIStackView = {
        let topStackView = UIStackView()
        topStackView.axis = .horizontal
        topStackView.spacing = kSmallPadding
        topStackView.distribution = .fillEqually
        topStackView.alignment = .center
        return topStackView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Filters"
        titleLabel.textColor = .black
        titleLabel.font = AppFonts.helveticaNeue(ofSize: 16)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private let horizontalSeperatorView: UIView = {
        let horizontalSeperatorView = UIView()
        horizontalSeperatorView.backgroundColor = .AmazonaGrey
        horizontalSeperatorView.translatesAutoresizingMaskIntoConstraints = false
        horizontalSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return horizontalSeperatorView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filter"
        view.backgroundColor = .white
        setupButtons()
        layoutViews()
    }
    
    // MARK: - Setup Methods for UI Elements
    
    private func setupResetButton() {
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(.AmazonaMagenta, for: .normal)
        resetButton.titleLabel?.font = AppFonts.helveticaNeue(ofSize: 16)
        resetButton.contentHorizontalAlignment = .left
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    private func setupDoneButton() {
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.AmazonaVibrantGreen, for: .normal)
        doneButton.titleLabel?.font = AppFonts.helveticaNeue(ofSize: 16)
        doneButton.contentHorizontalAlignment = .right
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    private func setupButtons() {
        setupResetButton()
        setupDoneButton()
    }
    
    // MARK: - Layout Methods for UI Elements
    
    private func layoutViews() {
        /**
         Put everything together
         */
        view.addSubview(topStackView)
        view.addSubview(horizontalSeperatorView)
        topStackView.addArrangedSubview(resetButton)
        topStackView.addArrangedSubview(titleLabel)
        topStackView.addArrangedSubview(doneButton)
        
        /**
         Set layouts with Easy Peasy
         */
        topStackView.easy.layout(
            Top(kMediumPadding).to(view.safeAreaLayoutGuide, .top),
            Leading(kMediumPadding),
            Trailing(kMediumPadding)
        )
        resetButton.easy.layout(
            Height().like(topStackView)
        )
        titleLabel.easy.layout(
            Height().like(topStackView)
        )
        doneButton.easy.layout(
            Height().like(topStackView)
        )
        horizontalSeperatorView.easy.layout(
            Top(kMediumPadding).to(topStackView, .bottom),
            Leading(),
            Trailing(),
            Height(1)
        )
    }
    
    // MARK: - Actions
    
    @objc func resetButtonTapped() {
        print("Reset button tapped")
    }
    
    @objc func doneButtonTapped() {
        print("Done button tapped")
        priceRangeSubject.onNext(selectedPriceRange)
        dismiss(animated: true)
    }
}

