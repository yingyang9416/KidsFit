//
//  DatePickerViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 2/5/21.
//

import UIKit

class DatePickerViewController: UIViewController {

    var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDatePicker()
    }

    func addDatePicker() {
        let datePicker = UIDatePicker()
        self.datePicker = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
        [datePicker.topAnchor.constraint(equalTo: view.topAnchor),
         datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         datePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor)].forEach { $0.isActive = true }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let presentationController = popoverPresentationController?.delegate as? WhiteboardViewController {
            presentationController.dateSelectedFromPopover = datePicker?.date
        }
    }
    
}
