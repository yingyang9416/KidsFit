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
    @IBOutlet var fistImageView: UIImageView!
    @IBOutlet var fistbumpCountLabel: UILabel!
    
    var post: Post?
    var likeIds = [String]()
    var liked: Bool {
        return likeIds.contains(UserDefaults.currentUser()?.userId ?? "")
    }

    
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
        
        if let imageUrlString = post.imageUrlString, !imageUrlString.isEmpty {
            postImage.isHidden = false
            postImage.sd_setImage(with: URL(string: imageUrlString), placeholderImage: UIImage.imageLoading)
        } else {
            postImage.isHidden = true
        }
        
        fistImageView.isUserInteractionEnabled = true
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(fistbumpTapped))
        fistImageView.addGestureRecognizer(gesture)
        
        // fetch user info
        FirebaseDatabaseHelper.shared.fetchUser(uid: post.userId) { (user) in
            DispatchQueue.main.async {
                self.userNameLabel.text = user?.firstName
                self.profileImage.sd_setImage(with: URL(string: user?.profileImageUrlString ?? ""), placeholderImage: UIImage.defaultUser)
            }
        } onFailure: { (_) in
            print("user name error")
        }

        // fetch likes
        FirebaseDatabaseHelper.shared.fetchLikes(for: post) { (result) in
            switch result {
            case .success(let likeIds):
                self.likeIds = likeIds
                DispatchQueue.main.async {
                    self.updateFistbumpView()
                }
            case .failure(_):
                print("failure fetch likes")
            }
        }
    }
    
    @objc func fistbumpTapped() {
        guard let post = self.post, let uid = UserDefaults.currentUser()?.userId else { return }
        
        liked ? likeIds.removeAll(where: { $0 == uid }) : likeIds.append(uid)
        FirebaseDatabaseHelper.shared.likePost(like: liked, post: post)
        updateFistbumpView()
    }
    
    func updateFistbumpView() {
        fistImageView.image = liked ? UIImage.fistbumpFilled : UIImage.fistbump
        fistbumpCountLabel.textColor = liked ? .black : .systemGray
        switch likeIds.count {
        case 0:
            fistbumpCountLabel.text = "No fistbumps yet"
        case 1:
            fistbumpCountLabel.text = "1 fistbump"
        default:
            fistbumpCountLabel.text = "\(likeIds.count) fistbumps"
        }
    }


    
}
