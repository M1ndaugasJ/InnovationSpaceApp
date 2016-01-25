//
//  PopoverViewController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/24/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    var addChallengeView: AddChallengeView?
    var rightButtonCallback: AddChallengeViewRightButtonCallback?
    var leftButtonCallback: AddChallengeViewLeftButtonCallback?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChallengeView = AddChallengeView(frame: containerView.frame)
        containerView.addSubview(addChallengeView!)
        
        addChallengeView?.rightButtonCallback = {
            self.rightButtonCallback!()
        }
        
        addChallengeView?.leftButtonCallback = {
            self.leftButtonCallback!()
        }
        
        //containerView =
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
