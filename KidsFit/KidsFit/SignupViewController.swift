//
//  SignupViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 1/30/21.
//

import UIKit
import Firebase
import SPAlert

class SignupViewController: UIViewController {
    
    @IBOutlet var firstNameView: TextfieldWithTitle!
    @IBOutlet var lastNameView: TextfieldWithTitle!
    @IBOutlet var emailView: TextfieldWithTitle!
    @IBOutlet var passwordView: TextfieldWithTitle!
    @IBOutlet var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardWhenTappedAround()
        [firstNameView, lastNameView, emailView, passwordView].forEach {
            $0?.type = .largeWhite
        }
        firstNameView.title = "First name"
        lastNameView.title = "Last name"
        emailView.title = "Email"
        passwordView.title = "Password"
        passwordView.isPasswordView = true
        signupButton.makeRounded()
        signupButton.layer.borderWidth = 2
        signupButton.layer.borderColor = UIColor.white.cgColor
    }
    
        
    @IBAction func signupTapped(_ sender: Any) {
        signupUser()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func signupUser() {
        guard let firstName = firstNameView.text, !firstName.isEmpty,
              let lastName = lastNameView.text, !lastName.isEmpty,
              let email = emailView.text, !email.isEmpty,
              let password = passwordView.text, !password.isEmpty else {
            FlashAlert.presentError(with: "Please fill all fields")
            return
        }

        let userDictionary = [FirebaseKey.firstName: firstName,
                              FirebaseKey.lastName: lastName,
                              FirebaseKey.email: email]
        FirebaseAuth.shared.signupUser(email: email, userDict: userDictionary, password: password) {
            let scene = UIApplication.shared.connectedScenes.first
            if let sceneDelegate = scene?.delegate as? SceneDelegate {
                sceneDelegate.rout()
            }
            SPAlert.present(message: "Welcome, \(firstName) \(lastName)!", haptic: .success)
        } onFailure: { (error) in
            SPAlert.present(message: error.localizedDescription, haptic: .error)
        }

    }

}
