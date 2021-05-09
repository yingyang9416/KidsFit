//
//  MeViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 2/7/21.
//

import UIKit

class MeViewController: UIViewController {
    
    @IBOutlet var postTableView: UITableView!
    var allPosts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadPosts {}
    }
    
    func setupTableView() {
        postTableView.register(cell: PostTableViewCell.self)
        postTableView.rowHeight = UITableView.automaticDimension
        postTableView.separatorStyle = UITableViewCell.SeparatorStyle.none

        postTableView.es.addPullToRefresh { [unowned self] in
            self.loadPosts {
                DispatchQueue.main.async {
                    postTableView.es.stopPullToRefresh()
                }
            }
        }
    }
    
    func loadPosts(completion: @escaping () -> ()) {
        FirebaseDatabaseHelper.shared.fetchMyPosts { (result) in
            switch result {
            case .success(let posts):
                self.allPosts = posts
                DispatchQueue.main.async {
                    self.postTableView.reloadData()
                }
            case.failure(let error):
                FlashAlert.present(error: error)
            }
            completion()
        }
    }
        
}

extension MeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: PostTableViewCell.self, indexPath: indexPath)
        cell.bind(post: allPosts[indexPath.row])
        return cell
    }
    
}
