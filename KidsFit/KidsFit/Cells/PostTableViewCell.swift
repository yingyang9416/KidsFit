//
//  PostTableViewCell.swift
//  KidsFit
//
//  Created by Steven Yang on 3/23/21.
//

import UIKit
import SDWebImage

class PostTableViewCell: UITableViewCell {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var contentTextLabel: UILabel!
    @IBOutlet var postImage: UIImageView!
    
    var post: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.makeRounded()
        selectionStyle = .none
    }

    func bind(post: Post) {
        self.post = post
        contentTextLabel.text = post.text
        if let date = post.date {
            dateLabel.text = date.displayableTimePast(toDate: Date())
        }
        FirebaseDatabaseHelper.shared.fetchUser(uid: post.userId) { (user) in
            DispatchQueue.main.async {
                self.userNameLabel.text = user?.firstName
                self.profileImage.sd_setImage(with: URL(string: user?.profileImageUrlString ?? ""), placeholderImage: UIImage.defaultUser)
            }
        } onFailure: { (_) in
            print("user name error")
        }

        
        if let imageUrlString = post.imageUrlString, !imageUrlString.isEmpty {
            postImage.isHidden = false
            postImage.sd_setImage(with: URL(string: imageUrlString), placeholderImage: UIImage.imageLoading)
        } else {
            postImage.isHidden = true
        }
    }
    
}
