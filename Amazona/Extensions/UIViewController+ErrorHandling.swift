//
//  UIViewController+ErrorHandling.swift
//  Amazona
//
//  Created by Mark Mckelvie on 3/8/24.
//

import Foundation

import UIKit

extension UIViewController {
    
    func showErrorAlert(_ error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    // If you also want to handle an error with a custom message, you can add an overloaded function.
    func showErrorAlert(withMessage message: String) {
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
