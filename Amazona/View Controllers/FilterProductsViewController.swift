//
//  FilterProductsViewController.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import EasyPeasy

class FilterProductsViewController: UIViewController {
    
    var viewModel: CategoriesViewModel
    
    var priceRangeSubject = BehaviorSubject<ClosedRange<Double>?>(value: nil)
    var selectedCategorySubject = BehaviorSubject<String?>(value: nil)
    var selectedRatingSubject = BehaviorSubject<Int?>(value: nil)
    
    private let doneButton = UIButton()
    private let resetButton = UIButton()
    private var selectedPriceRange: ClosedRange<Double> = 0.0...100.0
    private var categoriesCollectionView = UICollectionView(frame: .zero,
                                                            collectionViewLayout: UICollectionViewFlowLayout())
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
    
    private let categoriesLabel: UILabel = {
        let categoriesLabel = UILabel()
        categoriesLabel.text = "CATEGORIES"
        categoriesLabel.textColor = .AmazonaGrey
        categoriesLabel.font = AppFonts.helveticaNeue(ofSize: 16)
        categoriesLabel.textAlignment = .center
        return categoriesLabel
    }()
    
    private let horizontalSeperatorView: UIView = {
        let horizontalSeperatorView = UIView()
        horizontalSeperatorView.backgroundColor = .AmazonaGrey
        horizontalSeperatorView.translatesAutoresizingMaskIntoConstraints = false
        horizontalSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return horizontalSeperatorView
    }()
    
    // MARK: - Initializers
    
    init(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filter"
        view.backgroundColor = .white
        setupButtons()
        setupCollectionView()
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
    
    private func setupCollectionView() {
        categoriesCollectionView.register(CategoryCell.self, 
                                          forCellWithReuseIdentifier: kCategoryCellIdentifier)
        categoriesCollectionView.backgroundColor = .white
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
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
        view.addSubview(categoriesLabel)
        view.addSubview(categoriesCollectionView)
        
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
        categoriesLabel.easy.layout(
            Top(kMediumPadding).to(horizontalSeperatorView, .bottom),
            Leading(kMediumPadding)
        )
        categoriesCollectionView.easy.layout(
            Top(kSmallPadding).to(categoriesLabel, .bottom),
            Leading(kMediumPadding),
            Trailing(kMediumPadding),
            Bottom(kMediumPadding).to(view.safeAreaLayoutGuide, .bottom)
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

// MARK: - UICollectionViewDataSource

extension FilterProductsViewController: UICollectionViewDataSource {
    
    // In your cell for item at index path dataSource method:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCategoryCellIdentifier, for: indexPath) as! CategoryCell
        let category = viewModel.categories[indexPath.item]
        cell.configure(with: category)
        cell.delegate = self // Set the view controller as the delegate
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.categories.count
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FilterProductsViewController: UICollectionViewDelegateFlowLayout {
    /// Set the size of the cells based on the category name
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = viewModel.categories[indexPath.item]
        let width = category.name.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]).width + 20
        return CGSize(width: width, height: 40)
    }
}

// MARK: - UICollectionViewDelegate

extension FilterProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = viewModel.categories[indexPath.item]
        print("Selected category: \(category.name)")
    }
}

// MARK: - CategoryCellDelegate

extension FilterProductsViewController: CategoryCellDelegate {
    func categoryCell(_ cell: CategoryCell, didTapButtonFor category: Category) {
        
        guard let indexPath = categoriesCollectionView.indexPath(for: cell) else { return }

        /// Toggle the selection state and update UI
        let isSelected = !category.isSelected.value
        category.isSelected.accept(isSelected)

        /// Explicitly reconfigure the cell to reflect the updated state
        if let updatedCell = categoriesCollectionView.cellForItem(at: indexPath) as? CategoryCell {
            updatedCell.configure(with: category)
        }
    }
}



