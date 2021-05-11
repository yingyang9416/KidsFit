//
//  WODWorkoutTableViewCell.swift
//  KidsFit
//
//  Created by Steven Yang on 2/1/21.
//

import UIKit
import youtube_ios_player_helper

class WODWorkoutTableViewCell: UITableViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var playerView: YTPlayerView!
    @IBOutlet var illustrationView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.setShadow(color: .lightGray, opacity: 0.2, radius: 8)
        illustrationView.isHidden = true
    }
    
    func bind(wod: WOD?) {
        guard let wod = wod else {
            titleLabel.text = "No workout found"
            bodyLabel.text = ""
            playerView.isHidden = true
            illustrationView.isHidden = false
            return
        }
        
        illustrationView.isHidden = true
        titleLabel.text = wod.title ?? "WOD"
        bodyLabel.text = wod.workout
        if let videoId = wod.videoId {
            playerView.isHidden = false
            playerView.load(withVideoId: videoId)
        } else {
            playerView.isHidden = true
        }
    }
    
//    func bind(title: String?, body: String) {
//        titleLabel.text = title ?? "WOD"
//        bodyLabel.text = body
////        playerView.loadVideo(byURL: "https://youtu.be/TxH35Iqw89A", startSeconds: 0)
//        playerView.load(withVideoId: "-syN8aFZz0w")
////        playerView.loadVideo(byURL: "https://www.youtube.com/watch?v=-syN8aFZz0w", startSeconds: 0)
//    }
    
}
