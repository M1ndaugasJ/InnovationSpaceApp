//
//  UIButtonExtension.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/18/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//

import UIKit

extension UIButton {

    func enabledButtonStyle(){
        layer.cornerRadius = 6
        backgroundColor = UIColor.peterRiver()
        layer.borderColor = UIColor.peterRiver().CGColor
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        clipsToBounds = true
        alpha = 1
        layer.borderWidth = 1.5
    }
    
    func enabledButtonActionPerformedStyle(){
        layer.cornerRadius = 6
        backgroundColor = UIColor.clearColor()
        layer.borderColor = UIColor.emerald().CGColor
        setTitleColor(UIColor.emerald(), forState: .Normal)
        clipsToBounds = true
        alpha = 1
        layer.borderWidth = 1.5
    }
    
    func enableButtonStyleNoBackground(){
        layer.cornerRadius = 6
        clipsToBounds = true
        alpha = 1
        layer.borderWidth = 1.5
        backgroundColor = UIColor.clearColor()
        layer.borderColor = UIColor.peterRiver().CGColor
        setTitleColor(UIColor.peterRiver(), forState: .Normal)
    }
    
    func disabledButtonStyle(){
        layer.cornerRadius = 6
        backgroundColor = UIColor.whiteColor()
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        layer.borderColor = UIColor.lightGrayColor().CGColor
        layer.borderWidth = 1.5
        //enabled = false
        alpha = 0.5
    }
    
}