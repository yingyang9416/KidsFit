//
//  ViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 1/30/21.
//

import UIKit

class WhiteboardViewController: UIViewController {

    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarbutton = UIBarButtonItem(title: "Right", style: .plain, target: self, action: #selector(rightBarbuttonTapped))
        self.navigationItem.rightBarButtonItem  = rightBarbutton
        setDatePicker()
    }
    
    func setDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerEditingDidEnd), for: .editingDidEnd)
    }

    func addNavBarImage() {
        let navController = navigationController!
        let image = UIImage(named: "testLogo") //Your logo url here
        let imageView = UIImageView(image: image)
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    @objc func datePickerEditingDidEnd() {
        print("date is \(datePicker.date)")
    }
    
    @objc func rightBarbuttonTapped() {
        let datepicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    }

}

