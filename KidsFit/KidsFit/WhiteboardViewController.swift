//
//  ViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 1/30/21.
//

import UIKit
import SPAlert

class WhiteboardViewController: UIViewController {

    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet weak var whiteboardTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarbutton = UIBarButtonItem(title: "Right", style: .plain, target: self, action: #selector(rightBarbuttonTapped))
        self.navigationItem.rightBarButtonItem  = rightBarbutton
        setDatePicker()
        setupTableview()
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
    
    @IBAction func fetch(_ sender: Any) {
        
        FirebaseDatabaseHelper.shared.fetchWOD(date: datePicker.date, gymId: "gymid11223") { (wod) in
            print("sucess!")
            print(wod.workout)
        } onFailure: { (error) in
            
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
        default:
            return 8
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeue(cell: WODWorkoutTableViewCell.self, indexPath: indexPath)
            cell.bind(title: "Workout of the day", body: "push up 100\npull ups 100\nsquats 200")
            return cell
        default:
            let cell = tableView.dequeue(cell: WODCommentTableViewCell.self, indexPath: indexPath)
            return cell
        }
        
    }
    
    

}

