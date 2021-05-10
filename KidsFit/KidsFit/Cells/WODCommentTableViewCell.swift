//
//  WODCommentTableViewCell.swift
//  KidsFit
//
//  Created by Steven Yang on 2/1/21.
//

import UIKit
import SDWebImage

class WODCommentTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var fistImageView: UIImageView!
    @IBOutlet var fistCountLabel: UILabel!
    var comment: WODComment?
    var likeIds = [String]()
    var liked: Bool {
        return likeIds.contains(UserDefaults.currentUser()?.userId ?? "")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2

    }
    
    func bind(wodComment: WODComment) {
        comment = wodComment
        commentLabel.text = wodComment.content
        if let date = DateFormatter().date(from: wodComment.timeString, format: .fromJson) {
            dateLabel.text = date.displayableTimePast(toDate: Date())
        }
        
        fistImageView.isUserInteractionEnabled = true
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(fistbumpTapped))
        fistImageView.addGestureRecognizer(gesture)
        
        // fetch user info
        FirebaseDatabaseHelper.shared.fetchUser(uid: wodComment.userId) { (user) in
            DispatchQueue.main.async {
                self.titleLabel.text = user?.firstName
                self.profileImageView.sd_setImage(with: URL(string: user?.profileImageUrlString ?? ""), placeholderImage: UIImage.defaultUser)
            }
        } onFailure: { (error) in
            print(error.localizedDescription)
        }
        
        // fetch likes
        FirebaseDatabaseHelper.shared.fetchLikes(for: wodComment) { (result) in
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
        guard let comment = self.comment, let uid = UserDefaults.currentUser()?.userId else { return }
        
        liked ? likeIds.removeAll(where: { $0 == uid }) : likeIds.append(uid)
        FirebaseDatabaseHelper.shared.likeWODComment(like: liked, comment: comment)
        updateFistbumpView()
    }
    
    func updateFistbumpView() {
        fistImageView.image = liked ? UIImage.fistbumpFilled : UIImage.fistbump
        fistCountLabel.textColor = liked ? .black : .systemGray

        switch likeIds.count {
        case 0:
            fistCountLabel.text = "No fistbumps yet"
        case 1:
            fistCountLabel.text = "1 fistbump"
        default:
            fistCountLabel.text = "\(likeIds.count) fistbumps"
        }
    }
        
}
