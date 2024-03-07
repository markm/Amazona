//
//  AmazonaTests.swift
//  AmazonaTests
//
//  Created by Mark Mckelvie on 3/2/24.
//

import XCTest
import RxSwift
@testable import Amazona

final class AmazonaTests: XCTestCase {
    
    var viewModel: ProductsViewModel!
    var productService: MockProductService!
    var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        productService = MockProductService()
        viewModel = ProductsViewModel(productService: productService)
        viewModel.updateProducts(with: productService.mockProducs)
        disposeBag = DisposeBag() /// Reinitialize the disposeBag to clear out old subscriptions
    }

    override func tearDownWithError() throws {
        viewModel = nil
        productService = nil
        disposeBag = DisposeBag() /// Clear the disposeBag
    }

    func testFetchProductsUpdatesProductsObservable() async {
        /// Given: this expected product
        let expectedProducts = [Product(id: 1,
                                        title: "Test Product",
                                        price: 10.0,
                                        descriptionText: "Test Description",
                                        category: "Test Category",
                                        imageURLString: "",
                                        rating: nil)]
        productService.expectedProducts = expectedProducts
        
        /// When: fetching products
        do {
            try await viewModel.fetchProducts()
            
            /// Then: the products observable should be updated
            XCTAssertEqual(viewModel.productsRelay.value, expectedProducts)
        } catch {
            XCTFail("Fetching products failed with error: \(error)")
        }
    }
    
    func testSortByTopRated() {
        
        /// Given: products are sorted by top rating
        viewModel.sortProducts(productService.mockProducs, withSortOption: .topRated)
        
        /// When: Observing the sorted products
        let expectation = XCTestExpectation(description: "Products are sorted by top rating")
        
        viewModel.products
            .subscribe(onNext: { sortedProducts in
                /// Then: Verify the products are sorted by their rating in descending order
                XCTAssertTrue(sortedProducts[0].rating?.rate ?? 0 >= sortedProducts[1].rating?.rate ?? 0)
                XCTAssertTrue(sortedProducts[1].rating?.rate ?? 0 >= sortedProducts[2].rating?.rate ?? 0)
                
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSortByCostHighToLow() {
        /// Given: A sort option selected for sorting products by cost from high to low
        viewModel.sortProducts(productService.mockProducs, withSortOption: .costHighToLow)
        
        /// When: Observing the sorted products
        let expectation = XCTestExpectation(description: "Products are sorted by cost from high to low")
        
        viewModel.products
            .take(1) /// Take only the first emission to prevent waiting forever
            .subscribe(onNext: { sortedProducts in
                /// Then: Verify the products are sorted by their price in descending order
                let prices = sortedProducts.map { $0.price }
                let sortedPrices = prices.sorted(by: >) /// Sorted in descending order for comparison
                XCTAssertEqual(prices, sortedPrices, "Products are not sorted by cost from high to low correctly")
                
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testSortByCostLowToHigh() {
        /// Given: A sort option selected for sorting products by cost from low to high
        viewModel.sortProducts(productService.mockProducs, withSortOption: .costLowToHigh)
        
        /// When: Observing the sorted products
        let expectation = XCTestExpectation(description: "Products are sorted by cost from low to high")
        
        viewModel.products
            .take(1) /// Take only the first emission to prevent waiting forever
            .subscribe(onNext: { sortedProducts in
                /// Then: Verify the products are sorted by their price in ascending order
                let prices = sortedProducts.map { $0.price }
                let sortedPrices = prices.sorted(by: <) /// Sorted in ascending order for comparison
                XCTAssertEqual(prices, sortedPrices, "Products are not sorted by cost from low to high correctly")
                
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
