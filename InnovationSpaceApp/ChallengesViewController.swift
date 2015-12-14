//
//  ChallengesViewController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 11/23/15.
//  Copyright © 2015 Mindaugas. All rights reserved.
//

import UIKit

class ChallengesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var challenges: [Challenge] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.topViewController?.title = "eh"
        // Do any additional setup after loading the view.
        
        challenges.append(Challenge(name: "skiing"))
        challenges.append(Challenge(name: "diving"))
        challenges.append(Challenge(name: "jumping"))
        challenges.append(Challenge(name: "sliding"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("challenge", forIndexPath: indexPath) as! ChallengesViewCell
        cell.challengeName.text = challenges[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 0
        }
        return 0
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
