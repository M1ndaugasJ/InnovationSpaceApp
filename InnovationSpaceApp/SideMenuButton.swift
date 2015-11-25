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
    
    override func drawRect(rect: CGRect) {
        layer.borderWidth = 0.5
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
