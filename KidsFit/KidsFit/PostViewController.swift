//
//  PostViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 3/24/21.
//

import UIKit
import SPAlert

class PostViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var postTextView: UITextView!
    @IBOutlet var loadingSpinner: UIActivityIndicatorView!
    var imageUploaded = false
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        dismissKeyboardWhenTappedAround()
        setupViews()
    }
    
    func setupViews() {
        postTextView.placeholder = "How was your workout?"
        postImageView.isUserInteractionEnabled = true
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        postImageView.addGestureRecognizer(gesture)
    }
    
    @objc func imageTapped() {
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
        imageUploaded = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard let text = postTextView.text, !text.isEmpty, let uid = UserDefaults.currentUser()?.userId else {
            FlashAlert.presentError(with: "Please write some comments before submitting")
            return
        }
        
        doneButton.isEnabled = false
        let timeString = DateFormatter().timeString(from: Date(), format: .fromJson)
        var post = Post(text: text, timeString: timeString, userId: uid)
        post.gymId = currentGymId
        
        let image = imageUploaded ? postImageView.image : nil
        loadingSpinner.startAnimating()
            
        FirebaseDatabaseHelper.shared.insertPost(image: image, post: post) {
            DispatchQueue.main.async {
                FlashAlert.presentSuccess()
                self.navigationController?.popViewController(animated: true)
            }
        } onFailure: { (error) in
            DispatchQueue.main.async {
                self.doneButton.isEnabled = true
                self.loadingSpinner.stopAnimating()
                SPAlert.present(message: error.localizedDescription, haptic: .error)
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
