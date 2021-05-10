//
//  EmptyContentTableViewCell.swift
//  KidsFit
//
//  Created by Steven Yang on 5/10/21.
//

import UIKit

enum emptyContentType {
    case noComments
    case noPosts
}

class EmptyContentTableViewCell: UITableViewCell {

    @IBOutlet var commetsView: UIView!
    @IBOutlet var postsView: UIView!
    
    var type: emptyContentType = .noComments {
        didSet {
            commetsView.isHidden = type != .noComments
            postsView.isHidden = type != .noPosts
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
}
