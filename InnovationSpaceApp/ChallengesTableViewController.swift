//
//  ChallengesTableViewController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/18/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//

import UIKit
import CoreData

class ChallengesTableViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let addChallengeHeight: CGFloat = 70
    let dataController = DataController()
    var addChallengeView: AddChallengeView?
    var challenges: [Challenge] = []
    var addChallengeButtonImageView: UIImageView?
    var addChallengesBarButtonItem: UIBarButtonItem?
    var cameraController: CameraController?
    var challengeCreationController: ChallengeCreationViewController?
    var lastChallengeId: NSManagedObjectID?
    var addChallengesViewOpen: Bool = false
    var dimmingView: UIView? {
        didSet{
            dimmingView!.backgroundColor = UIColor(red: 200/255.0, green: 199/255.0, blue: 204/255.0, alpha: 0.5)
            dimmingView!.alpha = 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("challenges did load")
        challenges = fetchSavedChallenges()
        self.navigationController?.topViewController?.title = "Challenges"
        self.tableView.separatorStyle = .None
        self.tableView.delegate = self
        let image = UIImage(named: "addButtonWhite")?.imageWithRenderingMode(.AlwaysOriginal)
        
        addChallengeButtonImageView = UIImageView(image: image)
        //addChallengeButtonImageView?.autoresizingMask = .None
        
        addChallengeButtonImageView?.contentMode = .ScaleAspectFit
        let button = UIButton(type: .Custom)
        button.frame = CGRectMake(0, -2, 40, 40)
        
        button.addSubview(addChallengeButtonImageView!)
        button.addTarget(self, action: Selector("openAddChallengeView"), forControlEvents: .TouchUpInside)
        
        dimmingView = UIView(frame: self.view.frame)
        
        
        let gesture = UITapGestureRecognizer(target: self, action: "dimmingViewTouched:")
        dimmingView!.addGestureRecognizer(gesture)
        
        addChallengeButtonImageView?.center = button.center
        addChallengesBarButtonItem = UIBarButtonItem(customView: button)
        
        addChallengeView = AddChallengeView(frame: CGRectMake(0, 0, self.view.frame.width, addChallengeHeight))
        self.view.addSubview(addChallengeView!)
        self.view.insertSubview(dimmingView!, belowSubview: addChallengeView!)
        
        addChallengeView?.alpha = 0
        
        addChallengeView?.rightButtonCallback = {
            self.videoButtonClicked()
        }
        addChallengeView?.leftButtonCallback = {
            self.libraryButtonClicked()
        }
        
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = addChallengesBarButtonItem
        
        
        self.cameraController = CameraController(
               dismissalHandler: { picker in
                    self.dismissViewControllerAnimated(false, completion: {
                        picker.dismissViewControllerAnimated(true, completion: {})
        })
            }, presentCameraHandler: {
                    self.challengeCreationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("challengeCreationViewController") as? ChallengeCreationViewController
                    
                    self.challengeCreationController!.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
                    self.presentViewController(self.challengeCreationController!, animated: false, completion: {})
                    self.challengeCreationController!.view.alpha = 0
                
                    self.cameraController?.lastChallengeID = self.lastChallengeId
                    //self.cameraController!.imagePicker.viewWillAppear(true)
                    self.presentViewController(self.cameraController!.imagePicker, animated: true, completion: {
                        self.challengeCreationController!.view.alpha = 1
                        //self.cameraController!.imagePicker.viewDidAppear(true)
                    })
                
                    self.challengeCreationController?.savedChallengeCallback = {
                        self.challenges = self.fetchSavedChallenges()
                        self.tableView.reloadData()
                    }
                    
                    self.challengeCreationController!.modalPresentationStyle = UIModalPresentationStyle.FullScreen
                    
                    self.openAddChallengeView()
            }, dismissCameraWithPicture: { image in
                    self.challengeCreationController?.challengeImage = image
            }, dismissCameraWithVideo: { videoURL in
                    (self.challengeCreationController?.videoURL = videoURL)!
        })

        self.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0)
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("challenge", forIndexPath: indexPath) as! ChallengesViewCell
        let challenge = self.challenges[indexPath.row]
        let image = UIImage(contentsOfFile: ChallengeDataManipulationHelper.fileInDocumentsDirectory(challenge.imageLocation!))
        
        if let videoLocation = challenge.videoLocation {
            print("this is a video challenge \(challenge.videoLocation)")
            cell.playbackButtonImageView.alpha = 1.0
        } else {
            cell.playbackButtonImageView.alpha = 0.0
        }
        
        cell.challengeImageView.image = image
        cell.challengeBackgroundView.image = image
        cell.challengeName.text = challenge.challengeTitle
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func dimmingViewTouched(sender:UITapGestureRecognizer){
        print("touched the dimming view")
        openAddChallengeView()
    }
    
    func openAddChallengeView(){
        UIView.animateWithDuration(0.3, delay: 0, options: .LayoutSubviews, animations: {
            self.addChallengeButtonImageView!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
            self.addChallengesViewOpen = !self.addChallengesViewOpen
            if self.addChallengesViewOpen {
                self.addChallengeView!.alpha = 1
                self.dimmingView!.alpha = 1
                self.addChallengeView!.frame.origin.y += self.tableView.contentInset.top
            } else {
                self.addChallengeView!.alpha = 0
                self.dimmingView!.alpha = 0
                self.addChallengeView!.frame.origin.y -= self.tableView.contentInset.top
                
            }
            }, completion: { finished in
                print("challenges open \(self.addChallengesViewOpen)")
                if self.addChallengesViewOpen {
                    self.addChallengeButtonImageView!.image = UIImage(named: "closeButtonWhite")
                    self.navigationController?.topViewController?.title = "Add yours"
                } else {
                    self.addChallengeButtonImageView!.image = UIImage(named: "addButtonWhite")
                    self.navigationController?.topViewController?.title = "Challenges"
                    
                }
                self.addChallengeButtonImageView!.transform = CGAffineTransformIdentity
                
        })
    }
    
    func fetchSavedChallenges() -> [Challenge] {
        let moc = dataController.managedObjectContext
        let personFetch = NSFetchRequest(entityName: "Challenge")
        
        do {
            let fetchedChallenges = try moc.executeFetchRequest(personFetch) as! [Challenge]
            //print(fetchedChallenges)
            return fetchedChallenges
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
    
    func libraryButtonClicked() {
        if let cameraController = self.cameraController {
            cameraController.prepareToChooseFromLibrary()
        }
    }
    
    func videoButtonClicked() {
        if let cameraController = self.cameraController {
            cameraController.prepareForCapture()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "challengeSegue" {
            let challengeViewController = segue.destinationViewController as! SingleChallengeViewController
            if let challengeCell = sender as? ChallengesViewCell {
                let challenge = challenges[(tableView.indexPathForSelectedRow?.row)!]
                if let videoLocation = challenge.videoLocation {
                    challengeViewController.videoName = videoLocation
                }
                challengeViewController.challengeImageName = challenge.imageLocation!
                challengeViewController.challengeName = challengeCell.challengeName.text
            }
        }
    }

}
