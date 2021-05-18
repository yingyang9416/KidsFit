//
//  LoginViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 3/18/21.
//

import UIKit
import SPAlert

class LoginViewController: UIViewController {
    
    @IBOutlet var emailView: TextfieldWithTitle!
    @IBOutlet var passwordView: TextfieldWithTitle!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var forgetPasswordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardWhenTappedAround()
        emailView.type = .largeWhite
        emailView.title = "Email"
        passwordView.type = .largeWhite
        passwordView.title = "Password"
        passwordView.isPasswordView = true
        forgetPasswordLabel.isUserInteractionEnabled = true
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(forgetPasswordTapped))
        forgetPasswordLabel.addGestureRecognizer(gesture)
        loginButton.makeRounded()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailView.text, let pwd = passwordView.text else {
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
    
    @objc func forgetPasswordTapped() {
        let forgetPasswordVC = UIStoryboard(storyboard: .Authentication).instantiateViewController(withIdentifier: ForgetPasswordViewController.self)
        navigationController?.pushViewController(forgetPasswordVC, animated: true)
    }
}
