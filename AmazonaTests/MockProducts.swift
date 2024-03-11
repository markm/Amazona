//
//  MockProducts.swift
//  AmazonaTests
//
//  Created by Mark Mckelvie on 3/11/24.
//

import Foundation
@testable import Amazona

let BurtsBeesLipGloss = Product(id: 1,
                                title: "Burt's Bees Lip Gloss",
                                price: 10.0,
                                descriptionText: "The best lip gloss on the market",
                                category: "Cosmetics",
                                imageURLString: "",
                                rating: Rating(rate: 4.0, count: 772))

let YamahaSpeakers = Product(id: 2,
                             title: "Yamaha Speakers",
                             price: 390.0,
                             descriptionText: "Some of the best monitor speakers in the world!",
                             category: "Electronics",
                             imageURLString: "",
                             rating: Rating(rate: 5.0, count: 262))

let MacbookPro = Product(id: 3,
                         title: "Apple Mac Book Pro",
                         price: 10.0,
                         descriptionText: "Great computer!",
                         category: "Electronics",
                         imageURLString: "",
                         rating: Rating(rate: 3.0, count: 406))

let PassportHolder = Product(id: 4,
                             title: "Passport Holder",
                             price: 350.0,
                             descriptionText: "Fancy passport holder for your travels",
                             category: "Travel Accessories",
                             imageURLString: "",
                             rating: Rating(rate: 4.0, count: 300))

let RaybanSunglasses = Product(id: 5,
                               title: "Rayban Sunglasses",
                               price: 10.0,
                               descriptionText: "The best lip gloss on the market",
                               category: "Cosmetics",
                               imageURLString: "",
                               rating: Rating(rate: 1.5, count: 100))
