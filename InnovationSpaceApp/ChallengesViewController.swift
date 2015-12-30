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
        self.navigationController?.topViewController?.title = "Challenges"
        let barButtonItem : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("btnOpenAddView"))
        self.navigationController?.topViewController!.navigationItem.rightBarButtonItem = barButtonItem
        barButtonItem.tintColor = UIColor.blackColor()
        // Do any additional setup after loading the view.
        
        challenges.append(Challenge(name: "skiing", photo: "photo1"))
        challenges.append(Challenge(name: "diving", photo: "photo1"))
        challenges.append(Challenge(name: "jumping", photo: "photo1"))
        challenges.append(Challenge(name: "sliding", photo: "photo1"))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(index, animated: true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func btnOpenAddView(){
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("addChallengeViewController") as! AddChallengeViewController
        self.presentViewController(vc, animated: true, completion: nil)
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
        self.performSegueWithIdentifier("challengeSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if(section == 0){
//            return 0
//        }
        return 0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let challenge = segue.destinationViewController as! SingleChallengeViewController
        if let challengeCell = sender as? ChallengesViewCell {
            challenge.challengeName = challengeCell.challengeName.text
        }
    }

}
