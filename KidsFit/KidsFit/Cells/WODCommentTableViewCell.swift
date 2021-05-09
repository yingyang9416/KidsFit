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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2

    }
    
    func bind(wodComment: WODComment) {
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

    }
    
    @objc func fistbumpTapped() {
        fistImageView.image = UIImage.fistbumpFilled
        fistImageView.isUserInteractionEnabled = false
        
    }
        
}
