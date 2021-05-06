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

    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var emailField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameField.placeholder = "First Name"
        lastNameField.placeholder = "Last Name"
        emailField.placeholder = "Email"
        
    }
    
    @IBAction func signup(_ sender: Any) {
        signupUser()
    }
    
    @IBAction func currentUser(_ sender: Any) {
        let user = Auth.auth().currentUser
        print("currnt user :\(user?.uid)")
    }
    
    
    func signupUser() {

        let userDictionary = ["firstName": firstNameField.text,
                              "lastName": lastNameField.text,
                              "email": emailField.text]
        FirebaseAuth.shared.signupUser(email: emailField.text!, userDict: userDictionary, password: "Yy19940106") {
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
