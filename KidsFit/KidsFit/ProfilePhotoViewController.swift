//
//  ProfilePhotoViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 3/26/21.
//

import UIKit
import SPAlert
import SDWebImage

class ProfilePhotoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet var profileImageView: UIImageView!
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        fetchDisplayProfileImage()
    }
    
    func fetchDisplayProfileImage() {
        guard let uid = UserDefaults.currentUser()?.userId else { return }
        FirebaseDatabaseHelper.shared.fetchUser(uid: uid) { (user) in
            if let urlString = user?.profileImageUrlString {
                DispatchQueue.main.async {
                    self.profileImageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "kidsfitness1"))
                }
            } else {
                DispatchQueue.main.async {
                    self.profileImageView.image = UIImage(named: "kidsfitness1")
                }
            }
        } onFailure: { (_) in
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(named: "kidsfitness1")
            }
        }

    }
    
    @IBAction func changePhotoButtonTapped(_ sender: Any) {
        if imagePicker.sourceType == .camera {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }

        profileImageView.image = image
        imagePicker.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let image = profileImageView.image, let user = UserDefaults.currentUser() else { return }
        
        FirebaseDatabaseHelper.shared.upsertProfileImage(image: image, user: user) { (_) in
            DispatchQueue.main.async {
                SPAlert.present(title: "Successful!", preset: .done)
            }
        } onFailure: { (error) in
            DispatchQueue.main.async {
                SPAlert.present(message: error.localizedDescription, haptic: .error)
            }
        }

    }
}
