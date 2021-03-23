//
//  ViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 1/30/21.
//

import UIKit
import SPAlert
import EasyPeasy

let currentGymId = "gymid11223"

class WhiteboardViewController: UIViewController {

    @IBOutlet weak var whiteboardTableView: UITableView!
    @IBOutlet var commentContainerView: UIView!
    @IBOutlet var commentTextView: UITextView!
    
    var dateShown: Date = Date()
    var dateSelectedFromPopover: Date?
    var wod: WOD?
    var comments = [WODComment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateString = DateFormatter().dateString(from: dateShown, format: .readableMonthAndDate)
        let rightBarbutton = UIBarButtonItem(title: dateString, style: .plain, target: self, action: #selector(rightBarbuttonTapped))
        self.navigationItem.rightBarButtonItem  = rightBarbutton
        setupTableview()
        loadContent(for: dateShown, gymId: currentGymId)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        dismissKeyboardWhenTappedAround()
    }
    
    func setupTableview() {
        whiteboardTableView.register(cell: WODWorkoutTableViewCell.self)
        whiteboardTableView.register(cell: WODCommentTableViewCell.self)
        whiteboardTableView.rowHeight = UITableView.automaticDimension
        whiteboardTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        // add image header
        let headerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 300))
        headerImageView.image = UIImage(named: "kidsfitness1")
        whiteboardTableView.tableHeaderView = headerImageView

    }
        
    @objc func rightBarbuttonTapped() {
        let datePickerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePickerViewController")
        datePickerViewController.modalPresentationStyle = .popover
        datePickerViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        datePickerViewController.popoverPresentationController?.delegate = self
        self.present(datePickerViewController, animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
//        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//           return
//        }
        commentContainerView.isHidden = false
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        commentContainerView.isHidden = true
    }

    @IBAction func commentButtonTapped(_ sender: Any) {
        commentTextView.becomeFirstResponder()
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let content = commentTextView.text, !content.isEmpty else {
            SPAlert.present(message: "Please write some comment and then submit", haptic: .error)
            return
        }
        guard let userId = UserDefaults.currentUser()?.userId else {
            SPAlert.present(message: "We are not able to identify you, please try again later", haptic: .error)
            return
        }
        let timeString = DateFormatter().timeString(from: Date(), format: .fromJson)
        let comment = WODComment(content: content, timeString: timeString, userId: userId)
        let wodId = DateFormatter().timeString(from: dateShown, format: .dateIdFormat)
        FirebaseDatabaseHelper.shared.insertWODComment(gymId: currentGymId, wodId: wodId, comment: comment) {
            DispatchQueue.main.async {
                SPAlert.present(title: "Successful!", preset: .done)
            }
        } onFailure: { (error) in
            DispatchQueue.main.async {
                SPAlert.present(message: error.localizedDescription, haptic: .error)
            }
        }

        print("post tapped")
    }
    
    

    
    func loadContent(for date: Date, gymId: String) {
        let dateStringToShow = DateFormatter().dateString(from: date, format: .readableMonthAndDate)
        self.navigationItem.rightBarButtonItem?.title = dateStringToShow
        FirebaseDatabaseHelper.shared.fetchWOD(date: date, gymId: currentGymId) { (wod) in
            self.wod = wod
            self.whiteboardTableView.reloadData()
        } onFailure: { (error) in
            SPAlert.present(message: "Error getting the content", haptic: .error)
        }

        FirebaseDatabaseHelper.shared.fetchWODComments(date: date, gymId: gymId) { (comments) in
            self.comments = comments
            DispatchQueue.main.async {
                self.whiteboardTableView.reloadData()
            }
        } onFailure: { (error) in
            DispatchQueue.main.async {
                SPAlert.present(message: "Error getting the comments", haptic: .error)
            }
        }

    }
    

}

extension WhiteboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return comments.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeue(cell: WODWorkoutTableViewCell.self, indexPath: indexPath)
            if let wod = self.wod {
                cell.bind(title: wod.title, body: wod.workout)
            } else {
                cell.bind(title: "No workout found", body: "")
            }
            return cell
        case 1:
            let cell = tableView.dequeue(cell: WODCommentTableViewCell.self, indexPath: indexPath)
            cell.bind(wodComment: comments[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    

}

extension WhiteboardViewController: UIPopoverPresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        guard let dateSelected = dateSelectedFromPopover else { return }
        
        if DateFormatter().dateString(from: dateShown, format: .readableMonthAndDate) != DateFormatter().dateString(from: dateSelected, format: .readableMonthAndDate) {
            dateShown = dateSelected
            loadContent(for: dateShown, gymId: currentGymId)
        }
    }
}

extension WhiteboardViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {

    }
}

