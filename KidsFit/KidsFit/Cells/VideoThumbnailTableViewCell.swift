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
        var title = ""
        if let date = wod.date {
            title = "WOD\n" + DateFormatter().dateString(from: date, format: .shortReadableDateFormat)
        } else {
            title = "WOD"
        }
        titleLabel.text = title
        if let vid = wod.videoId {
            videoView.load(withVideoId: vid)
        }
    }
        
}
