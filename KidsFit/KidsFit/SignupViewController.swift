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
//        FirebaseAuth.shared.signupUser(email: "yingyang9416@gmail.com", password: "Yy19940106") {
//            print("success")
//        } onFailure: { (error) in
//            print("error")
//            SPAlert.present(message: error.localizedDescription, haptic: .error)
//
//        }
        let userDictionary = ["firstName": firstNameField.text,
                              "lastName": lastNameField.text,
                              "email": emailField.text]
        FirebaseAuth.shared.signupUser(email: emailField.text!, userDict: userDictionary, password: "Yy19940106") {
            SPAlert.present(title: "Successful!", preset: .done)
        } onFailure: { (error) in
            SPAlert.present(message: error.localizedDescription, haptic: .error)
        }

    }

}
