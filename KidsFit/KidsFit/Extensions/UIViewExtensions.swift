//
//  UIViewExtensions.swift
//  KidsFit
//
//  Created by Steven Yang on 2/9/21.
//

import Foundation
import UIKit

extension UIView {
    
    func setX(_ x: CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.x = x
        self.frame = frame
    }
    
    func setY(_ y:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.y = y
        self.frame = frame
    }
    
    func setWidth(_ width:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.width = width
        self.frame = frame
    }
    
    func setHeight(_ height:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.height = height
        self.frame = frame
    }
    
    func makeRounded() {
        layer.cornerRadius = frame.size.height/2
        clipsToBounds = true
    }
    
    func makeRoundedCorner(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func setShadow(color: UIColor, opacity: Float, radius: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = .zero
        layer.shadowRadius = radius

    }
}
