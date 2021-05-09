//
//  CommunityViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 2/3/21.
//

import UIKit
import ESPullToRefresh

class CommunityViewController: UIViewController {

    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet var addButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    var allPosts = [Post]()
    var lastKey: String?
    var isPaginating = false
    var lastContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
        loadPosts {}
    }
    
    func setupViews() {
        addButton.makeRounded()
        addButton.clipsToBounds = false
        addButton.setShadow(color: .black, opacity: 0.4, radius: 2)
//        navigationController?.navigationItem.backButtonDisplayMode = .minimal
//        navigationController?.navigationBar
    }
    
    func setupTableView() {
        postTableView.register(cell: PostTableViewCell.self)
        postTableView.rowHeight = UITableView.automaticDimension
        postTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        postTableView.es.addPullToRefresh {
            [unowned self] in
            lastKey = nil
            allPosts.removeAll()
            loadPosts {
                DispatchQueue.main.async {
                    postTableView.es.stopPullToRefresh()
                }
            }
        }
        
        postTableView.es.addInfiniteScrolling {
            [unowned self] in
            guard lastKey != nil else {
                DispatchQueue.main.async {
                    postTableView.es.stopLoadingMore()
                }
                return
            }
            
            guard !isPaginating else { return }
            loadPosts {
                DispatchQueue.main.async {
                    postTableView.es.stopLoadingMore()
                }
            }
        }
    }
    
    func loadPosts(completion: @escaping () -> ()) {
        isPaginating = true
        FirebaseDatabaseHelper.shared.fetchposts(lastKey: lastKey) { (posts) in
//            let bound = (low: self.allPosts.count, high: self.allPosts.count + posts.count)
            self.allPosts.append(contentsOf: posts)
            self.lastKey = posts.last?.timeString
//            let indexPaths = (bound.low..<bound.high).map { IndexPath(row: $0, section: 0) }
            DispatchQueue.main.async {
                self.postTableView.reloadData()
            }
            self.isPaginating = false
            completion()
        } onFailure: { (error) in
            self.isPaginating = false
            FlashAlert.present(error: error)
            completion()
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
    
    // this delegate is called when the tableview will start scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }

    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffset < scrollView.contentOffset.y { // did move up
            addButton.isHidden = true
        } else if self.lastContentOffset > scrollView.contentOffset.y { // did move down
            addButton.isHidden = false
        } else { // didn't move
            
        }
    }
}
