//
//  UserEntranceViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 2/6/21.
//

import UIKit

class UserEntranceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        print("flag: \(UserDefaults.checkUserLoggedIn())")
    }
    
    @IBAction func signup(_ sender: Any) {
//        navigationController?.pushViewController(UIViewController(), animated: true)
    }
}
