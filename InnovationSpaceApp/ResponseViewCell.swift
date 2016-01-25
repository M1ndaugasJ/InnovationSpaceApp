//
//  ResponseViewCell.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/25/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//

import UIKit

class ResponseViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addBorder(edges: .Bottom, colour: UIColor.placeholderTextColor(), thickness: 0.5)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
