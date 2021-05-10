//
//  UserEntranceViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 2/6/21.
//

import UIKit

class UserEntranceViewController: UIViewController {

    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.makeRounded()
        loginButton.clipsToBounds = false
        loginButton.setShadow(color: .black, opacity: 0.5, radius: 2)
        signupButton.makeRounded()
        signupButton.layer.borderWidth = 2
        signupButton.layer.borderColor = UIColor.white.cgColor
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func signup(_ sender: Any) {
//        navigationController?.pushViewController(UIViewController(), animated: true)
    }
}
