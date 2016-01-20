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
    
    let addChallengeHeight: CGFloat = 70
    var addChallengeView: AddChallengeView?
    var challenges: [Challenge] = []
    var addChallengeButtonImageView: UIImageView?
    var addChallengesBarButtonItem: UIBarButtonItem?
    var cameraController: CameraController?
    var challengeCreationController: ChallengeCreationViewController?
    var dimmingView: UIView? {
        didSet{
            dimmingView!.backgroundColor = UIColor(red: 200/255.0, green: 199/255.0, blue: 204/255.0, alpha: 0.5)
            dimmingView!.alpha = 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.topViewController?.title = "Challenges"
        self.tableView.separatorStyle = .None
        
        addChallengeButtonImageView = UIImageView(image: UIImage(named: "addpng"))
        addChallengeButtonImageView?.autoresizingMask = .None
        addChallengeButtonImageView?.contentMode = .Center
        addChallengeButtonImageView?.backgroundColor = UIColor.blackColor()
        let button = UIButton(type: .Custom)
        button.frame = CGRectMake(0, 0, 40, 40)
        button.backgroundColor = UIColor.brownColor()
        button.addSubview(addChallengeButtonImageView!)
        button.addTarget(self, action: Selector("btnOpenAddView"), forControlEvents: .TouchUpInside)
        
        dimmingView = UIView(frame: self.view.frame)
        
        
        let gesture = UITapGestureRecognizer(target: self, action: "dimmingViewTouched:")
        dimmingView!.addGestureRecognizer(gesture)
        
        addChallengeButtonImageView?.center = button.center
        addChallengesBarButtonItem = UIBarButtonItem(customView: button)
        addChallengesBarButtonItem?.imageInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, -40)
        
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
                    
                    self.presentViewController(self.cameraController!.imagePicker, animated: true, completion: {
                        self.challengeCreationController!.view.alpha = 1
                    })
                    
                    self.challengeCreationController!.modalPresentationStyle = UIModalPresentationStyle.FullScreen
                    
                    self.btnOpenAddView()
            }, dismissCameraWithPicture: { image in
                    self.challengeCreationController?.challengeImage = image
            }, dismissCameraWithVideo: { videoURL in
                    self.challengeCreationController?.videoURL = videoURL
        })

        self.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
        
        challenges.append(Challenge(name: "skiing", photo: "photo1"))
        challenges.append(Challenge(name: "diving", photo: "photo2"))
        challenges.append(Challenge(name: "jumping", photo: "photo1"))
        challenges.append(Challenge(name: "sliding", photo: "photo2"))
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
        cell.challengeImageView.image = UIImage(named: challenges[indexPath.row].photoName!)
        cell.challengeName.text = challenges[indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func dimmingViewTouched(sender:UITapGestureRecognizer){
        print("touched the dimming view")
        btnOpenAddView()
    }
    
    func btnOpenAddView(){
        UIView.animateWithDuration(0.1, animations: {
            self.addChallengeButtonImageView!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
            
            }, completion: {
                completed in
                self.addChallengeButtonImageView!.transform = CGAffineTransformMakeRotation(CGFloat(0))
                if self.addChallengeButtonImageView!.image == UIImage(named: "addpng") {
                    self.addChallengeButtonImageView!.image = UIImage(named: "closepropper")
                    UIView.animateWithDuration(0.1, animations: {
                        //self.isAddChallengesOpen = true
                        self.navigationController?.topViewController?.title = "Add yours"
                        self.addChallengeView!.alpha = 1
                        self.dimmingView!.alpha = 1
                        //self.addChallengeView!.frame = CGRectMake(0, self.addChallengeHeight, self.view.frame.width, self.addChallengeHeight)
                        print("add button pressed")
                        self.addChallengeView!.frame.origin.y += self.tableView.contentInset.top
                    })
                } else {
                    self.addChallengeButtonImageView!.image = UIImage(named: "addpng")
                    UIView.animateWithDuration(0.3, animations: {
                        self.navigationController?.topViewController?.title = "Challenges"
                        self.dimmingView!.alpha = 0
                        print("close button pressed")
                        self.addChallengeView!.alpha = 0
                        self.addChallengeView!.frame.origin.y -= self.tableView.contentInset.top
                        //self.addChallengeView!.frame = CGRectMake(0, -self.addChallengeHeight, self.view.frame.width, self.addChallengeHeight)

                    })
                }
        })
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
            let challenge = segue.destinationViewController as! SingleChallengeViewController
            if let challengeCell = sender as? ChallengesViewCell {
                challenge.challengeImageName = challenges[(tableView.indexPathForSelectedRow?.row)!].photoName!
                challenge.challengeName = challengeCell.challengeName.text
            }
        }
    }

}
