//
//  NavigationDelegate.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/18/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//

import UIKit

class NavigationDelegate: UIPercentDrivenInteractiveTransition, UINavigationControllerDelegate {

    @IBOutlet weak var navigationController: UINavigationController?
    
    private let animator = Animator()
    var interactionController: UIPercentDrivenInteractiveTransition?
    var cancelledTransitionViewController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let screenEdgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: Selector("panned:"))
        screenEdgePanGesture.edges = .Left
        //screenEdgePanGesture.
        //let panGesture = PanDirectionGestureRecognizer(direction: PanDirection.Horizontal, target: self, action: Selector("panned:"))
        self.navigationController!.view.addGestureRecognizer(screenEdgePanGesture)
    }
    
    func panned(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let point = gestureRecognizer.locationInView(self.navigationController!.view)
        let percent = fmaxf(fminf(Float(point.x / (UIScreen.mainScreen().bounds.width)), 1.0), 0.0)
        //print(percent)
        self.navigationController?.view.layer.speed = 1.0
        switch (gestureRecognizer.state){
        case .Began:
            self.interactionController = UIPercentDrivenInteractiveTransition()
            self.navigationController?.popViewControllerAnimated(true)
        case .Changed:
            self.interactionController!.updateInteractiveTransition(CGFloat(percent))
        case .Ended, .Cancelled:
            
            if percent > 0.15 {
                self.interactionController!.finishInteractiveTransition()
                print("finished")
            } else {
                self.interactionController!.cancelInteractiveTransition()
                self.navigationController?.view.layer.speed = 0.10
                self.navigationController?.view.layer.beginTime = CACurrentMediaTime()
                print("cancelled")
            }
            self.interactionController = nil
        default:
            NSLog("Unhandled state")
            self.interactionController = nil
        }

    }
    
    func navigationController(navigationController: UINavigationController,
        interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
            guard animationController is Animator else {
                return nil
            }
            return self.interactionController
    }
    
    func navigationController(navigationController: UINavigationController,
        animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController,
        toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            self.navigationController?.view.layer.speed = 1.0
            guard (toVC is SingleChallengeViewController && fromVC is ChallengesTableViewController) ||
            (toVC is ChallengesTableViewController && fromVC is SingleChallengeViewController) else {
                return nil
            }
            return animator
    }
    
}

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var selectedCellFrame: CGRect?
    
    func transitionDuration(context: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(context: UIViewControllerContextTransitioning) {
        if let challengesTableViewController = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as? ChallengesTableViewController,
            singleChallengeViewController = context.viewControllerForKey(UITransitionContextToViewControllerKey) as? SingleChallengeViewController {
                
                moveFromChallengesTableView(challengesTableViewController, toChallenge: singleChallengeViewController, withContext: context)
                
        } else if let challengesTableViewController = context.viewControllerForKey(UITransitionContextToViewControllerKey) as? ChallengesTableViewController,
            singleChallengeViewController = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as? SingleChallengeViewController {
                
                moveFromChallenge(singleChallengeViewController, toChallenges: challengesTableViewController, withContext: context)
        
        } else {
            print("&unexpected animation state&")
            print(context.description)
        }
    }
    
    
    private func moveFromChallenge(singleChallengeViewController: SingleChallengeViewController, toChallenges challengesTableViewController: ChallengesTableViewController, withContext context: UIViewControllerContextTransitioning) {
        
        
        let background = UIView(frame: challengesTableViewController.view.frame)
        let placeholderViewForCellImage = UIView(frame: selectedCellFrame!)
        
        
        background.backgroundColor = UIColor.whiteColor()
        background.alpha = 0.8
        
        context.containerView()!.addSubview(challengesTableViewController.view)
        context.containerView()!.insertSubview(background, belowSubview: challengesTableViewController.view)
        
        let yCoord = singleChallengeViewController.view.convertRect(singleChallengeViewController.tableView.frame, toView: singleChallengeViewController.view).origin.y
        
        let view = viewForTransition(singleChallengeViewController.challengeImage.image!, frame: CGRectMake(0, yCoord, singleChallengeViewController.challengeImage.frame.width, singleChallengeViewController.challengeImage.frame.height))

        
        placeholderViewForCellImage.backgroundColor = UIColor.whiteColor()
        challengesTableViewController.view.addSubview(placeholderViewForCellImage)
        challengesTableViewController.view.alpha = 0.0
        
        
        context.containerView()!.addSubview(view)
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseOut, animations: {
            singleChallengeViewController.view.alpha = 0.0
            background.alpha = 0.0
            challengesTableViewController.view.alpha = 1.0
            let frame = self.selectedCellFrame
            print("moving imageView to this frame \(frame)")
            view.frame = frame!
            
            }) { finished in
                view.alpha = 0.0
                //print("imageViewFinished with this frame \(imageView.frame)")
                view.removeFromSuperview()
                background.removeFromSuperview()
                placeholderViewForCellImage.removeFromSuperview()
                context.completeTransition(!context.transitionWasCancelled())
        }
        
    }

    
    private func moveFromChallengesTableView(challengesTableViewController: ChallengesTableViewController, toChallenge singleChallengeViewController: SingleChallengeViewController, withContext context: UIViewControllerContextTransitioning) {
        if let indexPath = challengesTableViewController.tableView.indexPathForSelectedRow,
            selectedCell = challengesTableViewController.tableView.cellForRowAtIndexPath(indexPath) as? ChallengesViewCell {
                
                context.containerView()!.addSubview(singleChallengeViewController.view)
                let contentFrame = challengesTableViewController.tableView.convertRect(challengesTableViewController.tableView.rectForRowAtIndexPath(indexPath), toView: challengesTableViewController.tableView.superview)
                
                let view = viewForTransition(selectedCell.challengeImageView.image!, frame: contentFrame)
                
                singleChallengeViewController.challengeImage.alpha = 0.0
                singleChallengeViewController.imageViewForBackground.alpha = 0.0
                singleChallengeViewController.videoPlayerView.alpha = 0.0
                singleChallengeViewController.view.alpha = 0.0
                singleChallengeViewController.view.addSubview(view)
                
                selectedCellFrame = challengesTableViewController.tableView.convertRect(challengesTableViewController.tableView.rectForRowAtIndexPath(indexPath), toView: challengesTableViewController.tableView.superview)
                
                
                UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.1, options: .CurveEaseInOut, animations: {
                    
                    view.frame = CGRect(x: 0.0, y: Double(singleChallengeViewController.view.convertRect(singleChallengeViewController.tableView.frame, toView: singleChallengeViewController.view).origin.y), width: Double(singleChallengeViewController.challengeImage.frame.width), height: Double(singleChallengeViewController.challengeImage.frame.height))
                    view.alpha = 1.0
                    
                    singleChallengeViewController.view.alpha = 1.0
                    
                    }) { finished in
                        singleChallengeViewController.view.sendSubviewToBack(view)
                        singleChallengeViewController.challengeImage.alpha = 1.0
                        singleChallengeViewController.imageViewForBackground.alpha = 1.0
                        singleChallengeViewController.videoPlayerView.alpha = 1.0
                        challengesTableViewController.tableView.deselectRowAtIndexPath(indexPath, animated: false)
                        view.removeFromSuperview()
                        context.completeTransition(!context.transitionWasCancelled())
                }
        }
    }
    
    private func viewForTransition(image1: UIImage, frame: CGRect) -> UIView{
        let view = UIView(frame: frame)
        view.contentMode = .Center
        let image = ChallengeDataManipulationHelper.resizeImage(image1, newWidth: 300)
        let imageView = UIImageView(frame: view.bounds)
        imageView.image = image
        imageView.transitionImageViewProperties()
        
        let imageViewForBackground = UIImageView(frame: view.bounds)
        imageViewForBackground.image = image
        
        let visualEffectView = UIVisualEffectView(frame: view.bounds)
        let blur = UIBlurEffect(style: .Light)
        visualEffectView.effect = blur
        
        view.addSubview(imageViewForBackground)
        view.addSubview(visualEffectView)
        view.addSubview(imageView)
        return view
    }
    

    
}

extension UIImageView {

    func transitionImageViewProperties(){
        clipsToBounds = true
        contentMode = .ScaleAspectFit
        //autoresizingMask = .None
    }
    
}