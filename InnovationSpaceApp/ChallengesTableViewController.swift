//
//  ChallengesTableViewController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/18/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//

import UIKit

class ChallengesTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var challenges: [Challenge] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.topViewController?.title = "Challenges"
        self.tableView.separatorStyle = .None
        let barButtonItem : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action:nil)
        self.navigationController?.topViewController!.navigationItem.rightBarButtonItem = barButtonItem
        barButtonItem.tintColor = UIColor.blackColor()
        // Do any additional setup after loading the view.
        self.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
        
        challenges.append(Challenge(name: "skiing", photo: "photo1"))
        challenges.append(Challenge(name: "diving", photo: "photo1"))
        challenges.append(Challenge(name: "jumping", photo: "photo1"))
        challenges.append(Challenge(name: "sliding", photo: "photo1"))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
//        if let index = tableView.indexPathForSelectedRow {
//            tableView.deselectRowAtIndexPath(index, animated: true)
//        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("challenge", forIndexPath: indexPath) as! ChallengesViewCell
        //pageImages[page].photoName!
        
        cell.challengeImageView.image = UIImage(named: challenges[indexPath.row].photoName!)
        
        print("cell image frame \(cell.challengeImageView.frame)")
        cell.challengeName.text = challenges[indexPath.row].name
        return cell
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.performSegueWithIdentifier("challengeSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
//    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //        if(section == 0){
        //            return 0
        //        }
        return 0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "challengeSegue" {
            let challenge = segue.destinationViewController as! SingleChallengeViewController
            if let challengeCell = sender as? ChallengesViewCell {
                challenge.challengeImageName = challenges[(tableView.indexPathForSelectedRow?.row)!].photoName!
                challenge.challengeName = challengeCell.challengeName.text
            }
        }
    }

}
