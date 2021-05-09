//
//  WorkoutVideosViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 5/9/21.
//

import UIKit

class WorkoutVideosViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var wods = [WOD]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(cell: VideoThumbnailTableViewCell.self)
        tableview.rowHeight = UITableView.automaticDimension
        fetchDisplayWods()
    }
    
    func fetchDisplayWods() {
        FirebaseDatabaseHelper.shared.fetchWODsWithVideo(gymId: currentGymId) { (result) in
            switch result {
            case .success(let wods):
                self.wods = wods
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    FlashAlert.present(error: error)
                }
            }
        }
    }
    
}

extension WorkoutVideosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeue(cell: VideoThumbnailTableViewCell.self, indexPath: indexPath)
        cell.bind(wod: wods[indexPath.row])
        return cell
    }
    
    
}

