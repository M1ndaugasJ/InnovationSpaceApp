//
//  DescriptionViewController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/18/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewContainerView: UIView!
    
    let placeholderText = "Add a few words about your challenge"
    var descriptionButtonCallback: ((enteredText: String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.disabledButtonStyle()
        cancelButton.enableButtonStyleNoBackground()
        textView.delegate = self
        textView.text = placeholderText
        //placeCursorToBeginning()
        textView.textColor = UIColor.placeholderTextColor()
        textViewContainerView.addBorder(edges: [.Top], colour: UIColor.lightGrayColor(), thickness: 0.5)
        //textView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        //textView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        //&&
//        if textView.text == placeholderText  {
//            placeCursorToBeginning()
//        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidChange(textView: UITextView) {
        if textView.text?.characters.count >= 1 {
            doneButton.enabledButtonStyle()
        } else {
            doneButton.disabledButtonStyle()
        }
        
        if placedPlaceholderText() {
            placeCursorToBeginning()
        } else if (textView.text.characters.count - placeholderText.characters.count == 1) {
            textView.text = String(textView.text.characters.first!)
            textView.textColor = UIColor.blackColor()
        }
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        placedPlaceholderText()
        textView.resignFirstResponder()
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.text == placeholderText  {
            placeCursorToBeginning()
        }
        return true
    }
    
    private func placedPlaceholderText() -> Bool{
        if textView.text == "" {
            textView.text = placeholderText
            textView.textColor = UIColor.placeholderTextColor()
            return true
        }
        return false
    }
    
    private func placeCursorToBeginning() {
        dispatch_async(dispatch_get_main_queue(), {
            self.textView.selectedRange = NSMakeRange(0,0)
        })
    }
    
    @IBAction func doneButtonTouchUpInside(sender: UIButton) {
        textView.resignFirstResponder()
        descriptionButtonCallback!(enteredText: self.textView.text)
        self.dismissViewControllerAnimated(true, completion: {})
    }

    @IBAction func cancelButtonTouchedUpInside(sender: UIButton) {
        textView.resignFirstResponder()
        descriptionButtonCallback!(enteredText: "")
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
