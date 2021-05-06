//
//  MyInfoViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 3/25/21.
//

import UIKit
import SPAlert

class MyInfoViewController: UIViewController {

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.text = UserDefaults.currentUser()?.firstName
        lastNameTextField.text = UserDefaults.currentUser()?.lastName
        emailTextField.text = UserDefaults.currentUser()?.email
        emailTextField.isUserInteractionEnabled = false
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let user = UserDefaults.currentUser(),
           let firstName = firstNameTextField.text,
           let lastName = lastNameTextField.text {
            user.firstName = firstName
            user.lastName = lastName
            FirebaseDatabaseHelper.shared.updateMyInfo(user: user) {
                DispatchQueue.main.async {
                    SPAlert.present(title: "Success!", preset: .done)
                }
            } onFailure: { (error) in
                DispatchQueue.main.async {
                    SPAlert.present(message: error.localizedDescription, haptic: .error)
                }
            }

        }
    }
}
