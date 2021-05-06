//
//  UIStoryboardExtension.swift
//  KidsFit
//
//  Created by Steven Yang on 3/25/21.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    enum Storyboard: String {
        case Main
        case Authentication
        case LaunchScreen
    }
    
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }
    
    public func instantiateViewController<T>(withIdentifier identifier: T.Type) -> T where T: UIViewController {
        let className = String(describing: identifier)
        guard let viewController = instantiateViewController(withIdentifier: className) as? T else {
            fatalError("cannot find view controller with identifier \(className)")
        }
        return viewController
    }
}
