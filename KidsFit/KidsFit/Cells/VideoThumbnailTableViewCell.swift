//
//  VideoThumbnailTableViewCell.swift
//  KidsFit
//
//  Created by Steven Yang on 5/9/21.
//

import UIKit
import youtube_ios_player_helper

class VideoThumbnailTableViewCell: UITableViewCell {

    @IBOutlet var videoView: YTPlayerView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func bind(wod: WOD) {
        titleLabel.text = "wod \(wod.dateString)"
    }
        
}
