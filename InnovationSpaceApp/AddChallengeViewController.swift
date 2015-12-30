//
//  AddChallengeViewController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 12/27/15.
//  Copyright © 2015 Mindaugas. All rights reserved.
//

import UIKit
import Spring

typealias DismissalHandler = () -> Void

class AddChallengeViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var handler: DismissalHandler?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)  {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    func commonInit() {
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.lightGrayColor()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func closeButtonTouchedDown(sender: SpringButton) {
        sender.animation = "pop"
        sender.duration = 1.0
        sender.animate()
    }
    
    @IBAction func closeButtonClicked(sender: SpringButton) {
        
        SpringAnimation.springWithCompletion(0.05, animations: {
            sender.alpha = 0.5
            }, completion: {(completed: Bool) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        if presented == self {
            return CustomPresentationController(presentedViewController: presented, presentingViewController: presenting)
        }
        
        return nil
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented == self {
            return CustomPresentationAnimationController(isPresenting: true)
        }
        else {
            return nil
        }
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed == self {
            return CustomPresentationAnimationController(isPresenting: false)
        }
        else {
            return nil
        }
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
