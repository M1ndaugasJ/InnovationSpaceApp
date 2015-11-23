//
//  SideMenuTableViewController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 11/23/15.
//  Copyright © 2015 Mindaugas. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {

    @IBOutlet var profileTableView: UITableView!
    let viewNames = ["Challenges"]
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SideMenuTableViewCell
        
        let object = viewNames[indexPath.row]
        cell.viewName.text = object
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.item == 0 {
            
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("challengesView") as! ChallengesViewController
            
            self.mm_drawerController.centerViewController = viewController
            
            //let navigationController = self.mm_drawerController.centerViewController as! UINavigationController
            
            //navigationController.viewControllers = [viewController]
            
            self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
        }
    }

}
