//
//  ForgetPasswordViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 5/12/21.
//

import UIKit
import SPAlert

class ForgetPasswordViewController: UIViewController {

    @IBOutlet var sendLinkButton: UIButton!
    @IBOutlet var emailView: TextfieldWithTitle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailView.type = .largeWhite
        emailView.title = "Email"
        sendLinkButton.makeRounded()
        sendLinkButton.clipsToBounds = false
        sendLinkButton.layer.borderWidth = 2
        sendLinkButton.layer.borderColor = UIColor.white.cgColor
        dismissKeyboardWhenTappedAround()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendLinkButtonTapped(_ sender: Any) {
        guard let email = emailView.text, !email.isEmpty else {
            FlashAlert.presentError(with: "Please fill your email address")
            return
        }
        FirebaseAuth.shared.sendPasswordReset(email: email) {
            DispatchQueue.main.async {
                SPAlert.present(title: "We sent a password reset link to your email", preset: .done)
            }
        } onFailure: { (error) in
            DispatchQueue.main.async {
                FlashAlert.present(error: error)
            }
        }

    }
}
