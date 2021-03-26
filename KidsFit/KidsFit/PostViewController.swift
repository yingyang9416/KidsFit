//
//  PostViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 3/24/21.
//

import UIKit
import SPAlert

class PostViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var postTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        dismissKeyboardWhenTappedAround()
    }
    
    @IBAction func uploadPhotoTapped(_ sender: Any) {
        if imagePicker.sourceType == .camera {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }

        postImageView.image = image
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let text = postTextView.text, let uid = UserDefaults.currentUser()?.userId else { return }
        
        let timeString = DateFormatter().timeString(from: Date(), format: .fromJson)
        let post = Post(text: text, timeString: timeString, userId: uid)
        
        FirebaseDatabaseHelper.shared.insertPost(image: postImageView.image, post: post) {
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
