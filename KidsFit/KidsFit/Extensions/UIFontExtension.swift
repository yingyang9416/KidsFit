//
//  UIFontExtension.swift
//  KidsFit
//
//  Created by Steven Yang on 5/10/21.
//

import Foundation
import UIKit

extension UIFont {
    static func avenirHeavy(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Heavy", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    static func avenirBook(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Book", size: size) ?? UIFont.systemFont(ofSize: size)
    }

}
