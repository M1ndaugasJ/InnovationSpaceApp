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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .Blue
        challengeImageView.transitionImageViewProperties()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
