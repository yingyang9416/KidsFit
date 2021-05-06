//
//  LoginViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 3/18/21.
//

import UIKit
import SPAlert

class LoginViewController: UIViewController {

    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardWhenTappedAround()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailField.text, let pwd = passwordField.text else {
            SPAlert.present(message: "Please fill all fields", haptic: .error)
            return
        }
        
        FirebaseAuth.shared.loginUser(email: email, password: pwd) {
            SPAlert.present(title: "Successful!", preset: .done)
            let scene = UIApplication.shared.connectedScenes.first
            if let sceneDelegate = scene?.delegate as? SceneDelegate {
                sceneDelegate.rout()
            }
        } onFailure: { (error) in
            SPAlert.present(message: error.localizedDescription, haptic: .error)
        }

    }
    
}
