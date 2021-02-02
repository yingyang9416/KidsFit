//
//  WODWorkoutTableViewCell.swift
//  KidsFit
//
//  Created by Steven Yang on 2/1/21.
//

import UIKit

class WODWorkoutTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(title: String, body: String) {
        titleLabel.text = title
        bodyLabel.text = body
    }
    
}
