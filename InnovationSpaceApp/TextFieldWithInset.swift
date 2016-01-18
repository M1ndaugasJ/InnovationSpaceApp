//
//  TextFieldWithInset.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/16/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//

import UIKit

class TextFieldWithInset: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    */
    
    var buttonHideKeyboard: UIButton?
    var callbackButtonPressed: (() -> Void)?
    let buttonWidth: CGFloat = 50
    let buttonHeight: CGFloat = 25
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func doneClicked(sender:UIButton)
    {
        callbackButtonPressed!()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        buttonHideKeyboard = UIButton(frame: CGRectMake(0, 0, buttonWidth, buttonHeight))
        
        guard let buttonHideKeyboard = self.buttonHideKeyboard else {
            return
        }
        
        buttonHideKeyboard.setTitle("Show", forState: .Normal)
        buttonHideKeyboard.titleLabel?.font = UIFont.systemFontOfSize(15, weight: UIFontWeightMedium)
        buttonHideKeyboard.setTitleColor(UIColor.peterRiver(), forState: .Normal)
        
        buttonHideKeyboard.layer.borderColor = UIColor.peterRiver().CGColor
        buttonHideKeyboard.layer.borderWidth = 1.5
        buttonHideKeyboard.layer.cornerRadius = 6
        //buttonHideKeyboard.hidden = true
        
        self.rightView = buttonHideKeyboard
        
        buttonHideKeyboard.addTarget(self, action: "doneClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.clearButtonMode = UITextFieldViewMode.Never
        self.rightViewMode = UITextFieldViewMode.Always
        
        borderStyle = .None
        addBorder(edges: [.Bottom, .Top], colour: UIColor.lightGrayColor(), thickness: 0.5)
    }
    
    override func rightViewRectForBounds(bounds: CGRect) -> CGRect {
        let rightBounds = CGRectMake(bounds.size.width-buttonWidth-10, (self.bounds.size.height-buttonHeight)/2, buttonWidth, buttonHeight)
        return rightBounds
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        guard buttonHideKeyboard?.hidden == true else {
            return CGRectMake(10, 10, bounds.size.width-buttonWidth-20, bounds.size.height)
        }
        return CGRectInset(bounds, 10, 10)
    }

}
