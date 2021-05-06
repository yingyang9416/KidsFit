//
//  MoreTableViewCell.swift
//  KidsFit
//
//  Created by Steven Yang on 3/25/21.
//

import UIKit

class MoreTableViewCell: UITableViewCell {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func bind(setting: SettingsCellStruct) {
        iconImageView.image = setting.iconImage
        titleLabel.text = setting.title
    }
    
}

struct SettingsCellStruct {
    var iconImage: UIImage?
    var title: String
}
