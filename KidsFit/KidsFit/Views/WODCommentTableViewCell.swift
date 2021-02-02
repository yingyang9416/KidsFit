//
//  WODCommentTableViewCell.swift
//  KidsFit
//
//  Created by Steven Yang on 2/1/21.
//

import UIKit

class WODCommentTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commentLabel.text = "I like it\nerewr \nser sf ssfss s\nffefdfdsf444"
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2

    }
    
}
