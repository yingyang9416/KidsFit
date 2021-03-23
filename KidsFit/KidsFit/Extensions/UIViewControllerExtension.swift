//
//  UIViewControllerExtension.swift
//  KidsFit
//
//  Created by Steven Yang on 2/7/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    func dismissKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

