//
//  MyInfoViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 3/25/21.
//

import UIKit
import SPAlert

class MyInfoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

//    @IBOutlet var firstNameTextField: UITextField!
//    @IBOutlet var lastNameTextField: UITextField!
//    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var firstNameView: TextfieldWithTitle!
    @IBOutlet var lastNameView: TextfieldWithTitle!
    @IBOutlet var emailNameView: TextfieldWithTitle!
    let imagePicker = UIImagePickerController()
    var imageUpdated = false

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.makeRounded()
        setupViews()
        fetchDisplayUserInfo()
        dismissKeyboardWhenTappedAround()
    }
    
    func setupViews() {
        imageView.isUserInteractionEnabled = true
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imagedTapped))
        imageView.addGestureRecognizer(gesture)
        imagePicker.delegate = self
        
        firstNameView.titleLabel.text = "First name"
        lastNameView.titleLabel.text = "Last name"
        emailNameView.titleLabel.text = "Email"
        emailNameView.isUserInteractionEnabled = false
        emailNameView.textField.textColor = .systemGray
        
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func fetchDisplayUserInfo() {
        
        guard let uid = UserDefaults.currentUser()?.userId else { return }
        FirebaseDatabaseHelper.shared.fetchUser(uid: uid) { (user) in
            DispatchQueue.main.async {
                self.firstNameView.textField.text = user?.firstName
                self.lastNameView.textField.text = user?.lastName
                self.emailNameView.textField.text = user?.email
            }
            if let urlString = user?.profileImageUrlString {
                DispatchQueue.main.async {
                    self.imageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage.defaultUser)
                }
            } else {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage.defaultUser
                }
            }
        } onFailure: { (_) in
            DispatchQueue.main.async {
                self.imageView.image = UIImage.defaultUser
            }
        }

    }
    
    @objc func saveButtonTapped() {
        guard let user = UserDefaults.currentUser() else {
            FlashAlert.present(error: AppError.noUserError)
            return
        }
        guard let firstName = firstNameView.textField.text,
              let lastName = lastNameView.textField.text,
              !firstName.isEmpty, !lastName.isEmpty else {
            FlashAlert.presentError(with: "Please fill all fields")
            return
        }
        
        user.firstName = firstName
        user.lastName = lastName
        FirebaseDatabaseHelper.shared.updateMyInfo(user: user) {
            DispatchQueue.main.async {
                SPAlert.present(title: "Success!", preset: .done)
                self.navigationController?.popViewController(animated: true)
            }
        } onFailure: { (error) in
            DispatchQueue.main.async {
                SPAlert.present(message: error.localizedDescription, haptic: .error)
            }
        }
        
        if imageUpdated, let image = imageView.image {
            FirebaseDatabaseHelper.shared.upsertProfileImage(image: image, user: user) { (_) in
//                DispatchQueue.main.async {
//                    SPAlert.present(title: "Successful!", preset: .done)
//                }
            } onFailure: { (error) in
//                DispatchQueue.main.async {
//                    SPAlert.present(message: error.localizedDescription, haptic: .error)
//                }
            }

        }

    }
    
    @objc func imagedTapped() {
        if imagePicker.sourceType == .camera {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        imageUpdated = true
        imageView.image = image
        imagePicker.dismiss(animated: true, completion: nil)
    }

    
}
