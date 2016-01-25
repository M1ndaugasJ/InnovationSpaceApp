//
//  DescriptionPopoverViewController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/25/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//

import UIKit

class DescriptionPopoverViewController: UIViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if let text = self.text {
            descriptionTextView.text = text
        }
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
