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
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardWhenTappedAround()
        guard let uid = UserDefaults.currentUser()?.userId else { return }
        
        FirebaseDatabaseHelper.shared.fetchUser(uid: uid) { (user) in
            print("is admin: \(user?.isAdmin)")
        } onFailure: { (_) in
            
        }

    }
    
    @IBAction func dateValueChanged(_ sender: Any) {
        let date = datePicker.date
        FirebaseDatabaseHelper.shared.fetchWOD(date: date, gymId: currentGymId) { (wod) in
            DispatchQueue.main.async {
                self.textView.text = wod?.workout
            }
        } onFailure: { (error) in
            FlashAlert.present(error: error)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let workout = textView.text else { return }
        
        FirebaseDatabaseHelper.shared.insertWOD(gymId: currentGymId, workout: workout, date: datePicker.date) {
            FlashAlert.presentSuccess()
        } onFailure: { (error) in
            FlashAlert.present(error: error)
        }

    }
}
