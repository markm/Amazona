//
//  FilterProductsViewController.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import EasyPeasy

class FilterProductsViewController: UIViewController {
    
    var viewModel: ProductsViewModel
    
    private let doneButton = UIButton()
    private let resetButton = UIButton()
    private let sortOptionsTableView = UITableView()
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
        titleLabel.text = kFiltersTitle
        titleLabel.textColor = .black
        titleLabel.font = AppFonts.helveticaNeue(ofSize: kRegularFontSize)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private let categoriesLabel: UILabel = {
        let categoriesLabel = UILabel()
        categoriesLabel.text = kCategoriesTitle
        categoriesLabel.textColor = .AmazonaGrey
        categoriesLabel.font = AppFonts.helveticaNeue(ofSize: kRegularFontSize)
        categoriesLabel.textAlignment = .left
        return categoriesLabel
    }()
    
    private let horizontalSeperatorView: UIView = {
        let horizontalSeperatorView = UIView()
        horizontalSeperatorView.backgroundColor = .AmazonaGrey
        horizontalSeperatorView.translatesAutoresizingMaskIntoConstraints = false
        horizontalSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return horizontalSeperatorView
    }()
    
    private let sortByLabel: UILabel = {
        let sortByLabel = UILabel()
        sortByLabel.text = kSortByLabelTitle
        sortByLabel.textColor = .AmazonaGrey
        sortByLabel.font = AppFonts.helveticaNeue(ofSize: kRegularFontSize)
        sortByLabel.textAlignment = .left
        return sortByLabel
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
        title = kFilterTitle
        view.backgroundColor = .white
        setupButtons()
        setupCollectionView()
        setupSortOptionsTableView()
        layoutViews()
    }
    
    // MARK: - Setup Methods for UI Elements
    
    private func setupResetButton() {
        resetButton.setTitle(kResetTitle, for: .normal)
        resetButton.setTitleColor(.AmazonaMagenta, for: .normal)
        resetButton.titleLabel?.font = AppFonts.helveticaNeue(ofSize: kRegularFontSize)
        resetButton.contentHorizontalAlignment = .left
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    private func setupDoneButton() {
        doneButton.setTitle(kDoneTitle, for: .normal)
        doneButton.setTitleColor(.AmazonaDarkBlue, for: .normal)
        doneButton.titleLabel?.font = AppFonts.helveticaNeue(ofSize: kRegularFontSize)
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
    
    private func setupSortOptionsTableView() {
        sortOptionsTableView.delegate = self
        sortOptionsTableView.dataSource = self
        sortOptionsTableView.tableFooterView = UIView()  /// Remove unused separators
        sortOptionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: kSortOptionCellIdentifier)

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
        view.addSubview(sortByLabel)
        view.addSubview(sortOptionsTableView)
        
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
            Height(kBorderWidth)
        )
        categoriesLabel.easy.layout(
            Top(kMediumPadding).to(horizontalSeperatorView, .bottom),
            Leading(kMediumPadding)
        )
        categoriesCollectionView.easy.layout(
            Top(kSmallPadding).to(categoriesLabel, .bottom),
            Leading(kMediumPadding),
            Trailing(kMediumPadding),
            Height(>=100)
        )
        sortByLabel.easy.layout(
            Top(kMediumPadding).to(categoriesCollectionView, .bottom),
            Leading(kMediumPadding)
        )
        sortOptionsTableView.easy.layout(
            Top(kSmallPadding).to(sortByLabel, .bottom),
            Leading(),
            Trailing(),
            Height(3 * 44)  /// Assuming a row height of 44 points, adjust as needed
        )
    }
    
    // MARK: - Actions
    
    @objc func resetButtonTapped() {
        viewModel.reset()
        sortOptionsTableView.reloadData()
    }
    
    @objc func doneButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension FilterProductsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCategoryCellIdentifier,
                                                      for: indexPath) as! CategoryCell
        let category = viewModel.categories[indexPath.item]
        cell.configure(with: category)
        cell.delegate = self
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
        /// get the width of the string, essentially, and add some padding
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: kRegularFontSize)]
        let width = category.name.size(withAttributes: attributes).width + 20
        return CGSize(width: width, height: kSmallSquareSize)
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
        
        if isSelected {
            viewModel.selectCategory(atIndex: indexPath.row)
        } else {
            viewModel.deselectCategory(atIndex: indexPath.row)
        }
        /// Explicitly reconfigure the cell to reflect the updated state
        if let updatedCell = categoriesCollectionView.cellForItem(at: indexPath) as? CategoryCell {
            updatedCell.configure(with: category)
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDataSource

extension FilterProductsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        kSortOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kSortOptionCellIdentifier, for: indexPath)
        cell.textLabel?.text = kSortOptions[indexPath.row].rawValue
        let isSelected = viewModel.isSortOptionSelected(atIndex: indexPath.row)
        cell.accessoryType = isSelected ? .checkmark : .none
        cell.tintColor = isSelected ? .AmazonaMagenta : .AmazonaGrey
        cell.textLabel?.textColor = isSelected ? .AmazonaMagenta : .AmazonaGrey
        return cell
    }
}

extension FilterProductsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectSortOption(atIndex: indexPath.row)
        tableView.reloadData()
    }
}




