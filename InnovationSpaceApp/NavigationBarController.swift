//
//  NavigationBarController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 11/25/15.
//  Copyright © 2015 Mindaugas. All rights reserved.
//

import UIKit

class NavigationBarController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addButton()
        self.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addButton(){
    
//        let barButtonItem : UIBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action: "clicked")
        let image : UIImage? = UIImage(named:"menu")!.imageWithRenderingMode(.AlwaysOriginal)
        let barButtonItem : UIBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "clicked")
        
        self.topViewController!.navigationItem.leftBarButtonItem = barButtonItem
        
    }
    
    func clicked(){
        self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
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
