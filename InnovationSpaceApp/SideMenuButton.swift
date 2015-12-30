//
//  SideMenuButton.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 11/25/15.
//  Copyright © 2015 Mindaugas. All rights reserved.
//

import UIKit

class SideMenuButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        layer.borderWidth = 0.5
        layer.backgroundColor = UIColor.whiteColor().CGColor
    }
    
    override func drawRect(rect: CGRect) {
        //titleLabel?.font = UIFont(name: "Avenir-Thin", size: 39)
        //titleLabel?.textColor = UIColor.blackColor()
    }
    
    override var highlighted: Bool {
        didSet {
            if highlighted {
                layer.borderColor = UIColor.lightGrayColor().CGColor
            } else {
                layer.borderColor = UIColor.blackColor().CGColor
            }
        }
    }

}
