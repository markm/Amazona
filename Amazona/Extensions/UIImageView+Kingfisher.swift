//
//  UIImageView+Kingfisher.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/10/24.
//

import UIKit
import Foundation
import Kingfisher

extension UIImageView {
    
    /**
     Uses Kingfisher to load image from URL and set it
     */
    func setImage(withURL url: URL?, completion: @escaping (LocalizedError?) -> Void) {
        kf.indicatorType = .activity
        let options = [
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ] as KingfisherOptionsInfo
        kf.setImage(with: url, options: options) { [weak self]
            result in
            switch result {
            case .success(_):
                completion(nil)
            case .failure(let error):
                print("Kingfisher error loading image: \(error.localizedDescription)")
                completion(ImageError.failedToLoadImage)
                self?.setDefaultImage()
            }
        }
    }
    
    private func setDefaultImage() {
        image = AppImages.launch
    }
}
