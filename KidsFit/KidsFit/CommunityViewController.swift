//
//  CommunityViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 2/3/21.
//

import UIKit

class CommunityViewController: UIViewController {

    @IBOutlet weak var postTableView: UITableView!
    let imagePicker = UIImagePickerController()
    var allPosts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadPosts()
    }
    
    func setupTableView() {
        postTableView.register(cell: PostTableViewCell.self)
        postTableView.rowHeight = UITableView.automaticDimension
        postTableView.separatorStyle = UITableViewCell.SeparatorStyle.none

    }
    
    func loadPosts() {
        FirebaseDatabaseHelper.shared.fetchAllPosts { (posts) in
            self.allPosts = posts
            DispatchQueue.main.async {
                self.postTableView.reloadData()
            }
        } onFailure: { (_) in
            print("fail")
        }

    }
        
}

extension CommunityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: PostTableViewCell.self, indexPath: indexPath)
        cell.bind(post: allPosts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
