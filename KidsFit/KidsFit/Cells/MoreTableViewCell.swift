//
//  MoreTableViewCell.swift
//  KidsFit
//
//  Created by Steven Yang on 3/25/21.
//

import UIKit

enum SettingCellType {
    case regular
    case primaryGym
    case signout
}

class MoreTableViewCell: UITableViewCell {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var accessoryLabel: UILabel!
    
    var type: SettingCellType = .regular {
        didSet {
            switch type {
            case .primaryGym:
                accessoryLabel.isHidden = false
                FirebaseDatabaseHelper.shared.fetchGymInfo(gymId: currentGymId) { (result) in
                    var text: String?
                    switch result {
                        case .success(let gym):
                            text = gym?.name
                        case .failure(_):
                            text = ""
                    }
                    DispatchQueue.main.async {
                        self.accessoryLabel.text = text
                    }
                }
            case .signout:
                accessoryLabel.isHidden = false
                let user = UserDefaults.currentUser()
                accessoryLabel.text = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
            case .regular:
                accessoryLabel.isHidden = true
            }
        }
    }
    
    var accessoryText: String? {
        get {
            accessoryLabel.text
        }
        set {
            accessoryLabel.text = newValue
        }
    }
    
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
