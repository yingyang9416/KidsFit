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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2

    }
    
    func bind(wodComment: WODComment) {
        commentLabel.text = wodComment.content
        if let date = DateFormatter().date(from: wodComment.timeString, format: .fromJson) {
            dateLabel.text = DateFormatter().dateString(from: date, format: .combinedDateTime)
        }
        FirebaseDatabaseHelper.shared.fetchUser(uid: wodComment.userId) { (user) in
            DispatchQueue.main.async {
                self.titleLabel.text = user?.firstName
                self.profileImageView.sd_setImage(with: URL(string: user?.profileImageUrlString ?? ""), placeholderImage: UIImage(named: "kidsfitness1"))
            }
        } onFailure: { (error) in
            print(error.localizedDescription)
        }

    }
    
}
