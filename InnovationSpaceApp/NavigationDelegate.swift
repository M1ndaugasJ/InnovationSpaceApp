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
        //let panGesture = PanDirectionGestureRecognizer(direction: PanDirection.Horizontal, target: self, action: Selector("panned:"))
        self.navigationController!.view.addGestureRecognizer(screenEdgePanGesture)
    }
    
    func panned(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let point = gestureRecognizer.locationInView(self.navigationController!.view)
        let percent = fmaxf(fminf(Float(point.x / 1375.0), 0.99), 0.0)
        self.navigationController?.view.layer.speed = 1.0
//        print("point \(point)")
//        print("percent \(percent)")
        switch (gestureRecognizer.state){
        case .Began:
            self.interactionController = UIPercentDrivenInteractiveTransition()
            self.navigationController?.popViewControllerAnimated(true)
        case .Changed:
            self.interactionController!.updateInteractiveTransition(CGFloat(percent))
        case .Ended, .Cancelled:
            
            if percent > 0.05 {
                self.interactionController!.finishInteractiveTransition()
                print("finished")
            } else {
                self.interactionController!.cancelInteractiveTransition()
                self.navigationController?.view.layer.speed = 0.08
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
            return self.interactionController
    }
    
    func navigationController(navigationController: UINavigationController,
        animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController,
        toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return animator
    }
    
}

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var selectedCellFrame: CGRect?
    
    func transitionDuration(context: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.8
    }
    
    func animateTransition(context: UIViewControllerContextTransitioning) {
        if let categoryVC = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as? ChallengesTableViewController,
            postListVC = context.viewControllerForKey(UITransitionContextToViewControllerKey) as? SingleChallengeViewController {
                moveFromChallengesTableView(categoryVC, toPosts:postListVC, withContext: context)
        } else if let categoryVC = context.viewControllerForKey(UITransitionContextToViewControllerKey) as? ChallengesTableViewController,
            postListVC = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as? SingleChallengeViewController {
                moveFromChallenge(postListVC, toCategories: categoryVC, withContext: context)
        } else {
            print("what")
            print(context.description)
        }
    }
    
    
    private func moveFromChallenge(postListVC: SingleChallengeViewController, toCategories categoryVC: ChallengesTableViewController, withContext context: UIViewControllerContextTransitioning) {
        
        
        let background = UIView(frame: categoryVC.view.frame)
        let placeholderViewForCellImage = UIView(frame: selectedCellFrame!)
        let imageView = UIImageView(frame: postListVC.challengeImage.frame)
        
        background.backgroundColor = UIColor.whiteColor()
        background.alpha = 0.8
        
        context.containerView()!.addSubview(categoryVC.view)
        context.containerView()!.insertSubview(background, belowSubview: categoryVC.view)
        
        placeholderViewForCellImage.backgroundColor = UIColor.whiteColor()
        categoryVC.view.addSubview(placeholderViewForCellImage)
        categoryVC.view.alpha = 0.0
        
        imageView.image = postListVC.challengeImage.image
        imageView.transitionImageViewProperties()
        context.containerView()!.addSubview(imageView)
        
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.90, initialSpringVelocity: 0.6, options: .CurveEaseOut, animations: {
            postListVC.view.alpha = 0.0
            background.alpha = 0.0
            categoryVC.view.alpha = 1.0
            imageView.frame = self.selectedCellFrame!
            print(imageView.frame)
            }) { finished in
                imageView.alpha = 0.0
                imageView.removeFromSuperview()
                background.removeFromSuperview()
                placeholderViewForCellImage.removeFromSuperview()
                context.completeTransition(!context.transitionWasCancelled())
        }
        
    }

    
    private func moveFromChallengesTableView(categoryVC: ChallengesTableViewController, toPosts postListVC: SingleChallengeViewController, withContext context: UIViewControllerContextTransitioning) {
        if let indexPath = categoryVC.tableView.indexPathForSelectedRow,
            selectedCell = categoryVC.tableView.cellForRowAtIndexPath(indexPath) as? ChallengesViewCell {
                
                context.containerView()!.addSubview(postListVC.view)
                let imageView = UIImageView(frame: categoryVC.tableView.convertRect(categoryVC.tableView.rectForRowAtIndexPath(indexPath), toView: categoryVC.tableView.superview))
                imageView.transitionImageViewProperties()
                imageView.image = selectedCell.challengeImageView.image
                
                postListVC.challengeImage.alpha = 0.0
                postListVC.view.alpha = 0.0
                postListVC.view.addSubview(imageView)
                
                selectedCellFrame = categoryVC.tableView.convertRect(categoryVC.tableView.rectForRowAtIndexPath(indexPath), toView: categoryVC.tableView.superview)
                
                UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.1, options: .CurveEaseInOut, animations: {
                    print("nav bar height \(postListVC.navigationController?.navigationBar.frame.height)")
                    imageView.frame = CGRect(x: 0.0, y: Double(postListVC.challengeImage.frame.origin.y), width: Double(imageView.frame.width), height: Double(postListVC.challengeImage.frame.height))
                    imageView.alpha = 1.0
                    
                    postListVC.view.alpha = 1.0
                    
                    }) { finished in
                        postListVC.view.sendSubviewToBack(imageView)
                        let autoLayoutViews = [postListVC.challengeImage]
                        for view in autoLayoutViews { view.setNeedsUpdateConstraints() }
                        postListVC.challengeImage.alpha = 1.0
                        categoryVC.tableView.deselectRowAtIndexPath(indexPath, animated: false)
                        imageView.removeFromSuperview()
                        context.completeTransition(!context.transitionWasCancelled())
                }
        }
    }
    
}

extension UIImageView {

    func transitionImageViewProperties(){
        clipsToBounds = true
        contentMode = .ScaleAspectFill
    }
    
}