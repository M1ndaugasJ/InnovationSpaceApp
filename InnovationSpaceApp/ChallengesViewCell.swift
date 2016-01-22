//
//  ChallengesViewCell.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 12/7/15.
//  Copyright © 2015 Mindaugas. All rights reserved.
//

import UIKit

class ChallengesViewCell: UITableViewCell {

    @IBOutlet weak var challengeName: UILabel!
    @IBOutlet weak var challengeImageView: UIImageView!
    @IBOutlet weak var challengeBackgroundView: UIImageView!
    @IBOutlet weak var challengeBackgroundVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var wholeContentView: UIView!
    @IBOutlet weak var playbackButtonImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playbackButtonImageView.contentMode = .Center
        playbackButtonImageView.image = UIImage(named: "play")
        playbackButtonImageView.alpha = 0.0
        //self.selectionStyle = .Blue
        //visualEffectView.backgroundColor = UIColor.blackColor()
        challengeImageView.transitionImageViewProperties()
        self.layoutMargins = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false
        print("cell initialized")
        // Initialization code
    }

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        let blur = UIBlurEffect(style: .Light)
//        challengeBackgroundVisualEffectView.effect = blur
//        // Configure the view for the selected state
//    }

    
}
