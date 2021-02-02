//
//  UITableViewExtenstion.swift
//  KidsFit
//
//  Created by Steven Yang on 2/1/21.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cell: T.Type) {
        register(UINib(nibName: cell.cellId, bundle: nil),
                 forCellReuseIdentifier: cell.cellId)
    }
    
    func dequeue<T: UITableViewCell>(cell: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.cellId, for: indexPath) as! T
    }
}
