//
//  ViewController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 11/23/15.
//  Copyright © 2015 Mindaugas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITabBarDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    

    var profileView:UIViewController?
    var challengesView:UIViewController?
    var currentViewController: UIViewController?
    
    
    
    @IBAction func menuTapped(sender: UIButton) {
        self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    @IBAction func scrollButtonTaped(){
        removeControllerContent(currentViewController)
        addControllerContent(profileView!)
    }
    
    @IBAction func collectionButtonTaped(){
        removeControllerContent(currentViewController)
        addControllerContent(challengesView!)
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        NSLog(item.title!)
        if item.title == "Challenges"{
            collectionButtonTaped()
        }
        if item.title == "You"{
            scrollButtonTaped()
        }
    }
    
    private func addControllerContent(content: UIViewController){
        self.addChildViewController(content)
        content.view.frame = containerView.frame
        containerView.addSubview((content.view)!)
        content.didMoveToParentViewController(self)
        currentViewController = content
    }
    
    private func removeControllerContent(content: UIViewController?){
        if let content = content {
            
            content.willMoveToParentViewController(nil)
            content.view.removeFromSuperview()
            content.removeFromParentViewController()
            currentViewController = nil
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        profileView = (self.storyboard?.instantiateViewControllerWithIdentifier("profileView"))!
        challengesView = (self.storyboard?.instantiateViewControllerWithIdentifier("challengesView"))!
//        self.addChildViewController(challengesView!)
//        challengesView!.view.frame = containerView.frame
//        containerView.addSubview((challengesView!.view)!)
//        challengesView!.didMoveToParentViewController(self)
//        currentViewController = challengesView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

