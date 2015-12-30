//
//  CustomPresentationAnimationController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 12/28/15.
//  Copyright © 2015 Mindaugas. All rights reserved.
//

import UIKit
import Spring

class CustomPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    let isPresenting :Bool
    let duration :NSTimeInterval = 0.5
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        
        super.init()
    }
    
    
    // ---- UIViewControllerAnimatedTransitioning methods
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)  {
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext)
        }
        else {
            animateDismissalWithTransitionContext(transitionContext)
        }
    }
    
    func animatePresentationWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let presentedController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey),
            let containerView = transitionContext.containerView()
            else {
                return
        }
        let springView = presentedControllerView as! SpringView
        
        presentedControllerView.frame = transitionContext.finalFrameForViewController(presentedController)
        containerView.addSubview(presentedControllerView)
        
        SpringAnimation.springWithCompletion(self.duration, animations: {
            springView.animate()
            }, completion: {(completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
        })
    }
    
    func animateDismissalWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let presentedControllerView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            else {
                return
        }
        let springView = presentedControllerView as! SpringView
        
        SpringAnimation.springWithCompletion(self.duration, animations: {
            //
            springView.animation = "zoomOut"
            springView.curve = "easeIn"
            springView.duration = 1.0
            springView.animate()
            //springView.center.y += containerView.bounds.size.height
            }, completion: {(completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
        })
      
    }
    
}
