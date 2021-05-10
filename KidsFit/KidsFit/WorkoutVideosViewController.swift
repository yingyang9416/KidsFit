//
//  WorkoutVideosViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 5/9/21.
//

import UIKit
import ESPullToRefresh

class WorkoutVideosViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var wods = [WOD]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchDisplayWods {}
        
    }
    
    func setupViews() {
        tableview.register(cell: VideoThumbnailTableViewCell.self)
        tableview.rowHeight = UITableView.automaticDimension
        tableview.separatorStyle = .none
        tableview.es.addPullToRefresh { [unowned self] in
            self.fetchDisplayWods {
                DispatchQueue.main.async {
                    tableview.es.stopPullToRefresh()
                }
            }
        }
    }
    
    func fetchDisplayWods(completion: @escaping () -> ()) {
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
            completion()
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

