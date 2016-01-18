//
//  UncoveredContentViewController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/16/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//

import UIKit

class UncoveredContentViewController: UIViewController {

    var hideButtonEnableCallback: (() -> Void)?
    var hideButtonDisableCallback: (() -> Void)?
    var activeField: UITextField?
    var changedY = false
    var keyboardHeight: CGFloat = 300
    var viewToMove: UIView?
    var viewToMoveBottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillShow(sender: NSNotification) {
        let kbSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        print("kb size \(kbSize)")
        keyboardHeight = kbSize!.height
        if !changedY {
            UIView.animateWithDuration(0.1, animations: {
                self.viewToMoveBottomConstraint.constant += self.keyboardHeight
                self.viewToMove?.layoutIfNeeded()
                self.changedY = true
            })
        }
        
//        guard activeField != nil else {
//            return
//        }
        
        hideButtonEnableCallback!()
        
    }
    
    func keyboardWillHide(sender: NSNotification) {
        print("viewToMove frame keyboard hide \(viewToMove!.frame)")
        
        UIView.animateWithDuration(0.1, animations: {
            self.viewToMoveBottomConstraint.constant -= self.keyboardHeight
            self.viewToMove?.layoutIfNeeded()
        })
        
        //hideButtonDisableCallback!()
        
        changedY = false
    }
    
    deinit {
        print("$DEINIT UNCOVERED$")
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    @IBAction func textFieldEditingDidBegin(sender: UITextField){
        //println("did begin")
        activeField = sender
    }
    
    @IBAction func textFieldEditingDidEnd(sender: UITextField) {
        //println("did end")
        activeField = nil
    }

}
