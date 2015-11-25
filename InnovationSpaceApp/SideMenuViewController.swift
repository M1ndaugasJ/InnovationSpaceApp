//
//  SideMenuViewController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 11/25/15.
//  Copyright © 2015 Mindaugas. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {

    @IBOutlet weak var challengesButton: UIButton!
    
    @IBOutlet weak var profileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    @IBAction func challengesButtonClicked(sender: UIButton) {
        
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("challengesView") as! ChallengesViewController
        
        let navigationController = self.mm_drawerController.centerViewController as! NavigationBarController
        
        navigationController.viewControllers = [viewController]
        
        self.mm_drawerController.centerViewController = navigationController
        navigationController.addButton()
        self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }

    @IBAction func profileButtonClicked(sender: UIButton) {
        
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("profileView") as! ProfileViewController
        
        let navigationController = self.mm_drawerController.centerViewController as! NavigationBarController
        
        
        navigationController.viewControllers = [viewController]
        
        self.mm_drawerController.centerViewController = navigationController
        navigationController.addButton()
        self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
    }

}
