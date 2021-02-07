//
//  ViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 1/30/21.
//

import UIKit
import SPAlert

let currentGymId = "gymid11223"

class WhiteboardViewController: UIViewController {

    @IBOutlet weak var whiteboardTableView: UITableView!
    
    var dateShown: Date = Date()
    var dateSelectedFromPopover: Date?
    var wod: WOD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateString = DateFormatter().dateString(from: dateShown, format: .readableMonthAndDate)
        let rightBarbutton = UIBarButtonItem(title: dateString, style: .plain, target: self, action: #selector(rightBarbuttonTapped))
        self.navigationItem.rightBarButtonItem  = rightBarbutton
        setupTableview()
        loadContent(for: dateShown, gymId: currentGymId)
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
        
    @objc func rightBarbuttonTapped() {
        let datePickerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePickerViewController")
        datePickerViewController.modalPresentationStyle = .popover
        datePickerViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        datePickerViewController.popoverPresentationController?.delegate = self
        self.present(datePickerViewController, animated: true)
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
            if let wod = self.wod {
                cell.bind(title: wod.title, body: wod.workout)
            } else {
                cell.bind(title: "No workout found", body: "")
            }
            return cell
        default:
            let cell = tableView.dequeue(cell: WODCommentTableViewCell.self, indexPath: indexPath)
            return cell
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

