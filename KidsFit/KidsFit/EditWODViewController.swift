//
//  EditWODViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 5/6/21.
//

import UIKit
import SPAlert

class EditWODViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var titleField: TextfieldWithTitle!
    @IBOutlet var videoIdField: TextfieldWithTitle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardWhenTappedAround()
        setupViews()
        loadWODInfo()
        guard let uid = UserDefaults.currentUser()?.userId else { return }
        
        FirebaseDatabaseHelper.shared.fetchUser(uid: uid) { (user) in
            print("is admin: \(user?.isAdmin)")
        } onFailure: { (_) in
            
        }

    }
    
    func setupViews() {
        titleField.titleLabel.text = "Title (optional)"
        videoIdField.titleLabel.text = "Youtube video id (optional)"
        textView.placeholder = "workout of the day..."
        
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
        navigationController?.navigationBar.tintColor = .white
    }
    
    func loadWODInfo() {
        let date = datePicker.date
        FirebaseDatabaseHelper.shared.fetchWOD(date: date, gymId: currentGymId) { (wod) in
            DispatchQueue.main.async {
                self.titleField.textField.text = wod?.title
                self.videoIdField.textField.text = wod?.videoId
                self.textView.text = wod?.workout
            }
        } onFailure: { (error) in
            FlashAlert.present(error: error)
        }
    }
    
    @IBAction func dateValueChanged(_ sender: Any) {
        loadWODInfo()
    }
    
    @objc func saveButtonTapped() {
        guard let workout = textView.text, !workout.isEmpty else {
            FlashAlert.presentError(with: "Please fill workout")
            return
        }
        let dateString = DateFormatter().dateString(from: datePicker.date, format: .dateIdFormat)
        let wod = WOD(gymId: currentGymId, date: datePicker.date, title: titleField.textField.text, workout: workout, dateString: dateString, videoId: videoIdField.textField.text)
        
        FirebaseDatabaseHelper.shared.upsert(wod: wod) { (result) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    FlashAlert.presentSuccess()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    FlashAlert.present(error: error)
                }
            }
        }

    }
}
