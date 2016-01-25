//
//  SingleChallengeViewController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 12/18/15.
//  Copyright © 2015 Mindaugas. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class SingleChallengeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var visualEffectViewBackground: UIVisualEffectView!
    @IBOutlet weak var challengeImage: UIImageView!
    @IBOutlet weak var imageViewForBackground: UIImageView!
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addResponseButton: UIButton!
    @IBOutlet weak var bottomControlsView: UIView!
    @IBOutlet weak var descriptionButton: UIButton!
    @IBOutlet weak var noResponseView: UIView!
    
    
    var challengeName: String?
    var videoName: String?
    var challengeImageName: String?
    var challenge: Challenge?
    var responses: [Response]?
    var videoPlayer: VideoPlayController?
    var cameraController: CameraController?
    var dataController: DataController?
    var dataSaveHelper: DataSaveHelper?
    var saveSuccessBlock: (()->Void)?
    var viewedResponse: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(challenge: Challenge){
        super.init(nibName: nil, bundle: nil)
        self.challenge = challenge
        self.challengeName = challenge.challengeTitle
        self.challengeImageName = challenge.imageLocation
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(contentsOfFile: ChallengeDataManipulationHelper.fileInDocumentsDirectory(challenge!.imageLocation!))
        self.navigationController?.topViewController?.title = challenge!.challengeTitle!
        descriptionButton.enableButtonStyleNoBackground()
        
        self.challengeImage.image = image
        self.responses = challenge?.getChallengeResponses()
        
        if (self.responses != nil) && self.responses?.count > 0 {
            noResponseView.hidden = true
        }
        
        if let videoLocation = challenge!.videoLocation {
            self.videoName = videoLocation
        }
        
        if let description = self.challenge!.challengeDescription {
            let trimmedDesc = description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            guard trimmedDesc.characters.count > 0 else {
                descriptionButton.disabledButtonStyle()
                descriptionButton.enabled = false
                return
            }
        } else {
            descriptionButton.disabledButtonStyle()
            descriptionButton.enabled = false
        }
        
        saveSuccessBlock = {
            self.responses = self.challenge?.getChallengeResponses()
            self.noResponseView.hidden = true
            self.tableView.reloadData()
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        bottomControlsView.addBorder(edges: .Top, colour: UIColor.placeholderTextColor(), thickness: 0.5)
        
        challengeImage.transitionImageViewProperties()
        self.imageViewForBackground.image = image
        self.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0)
        self.automaticallyAdjustsScrollViewInsets = false
        setupCameraController()
        addResponseButton.enabledButtonStyle()
        
        let headerViewRect = self.tableView.convertRect(visualEffectViewBackground.bounds, toView: self.tableView.superview)
        let noResponsesViewRect = CGRectMake(0, headerViewRect.origin.y+headerViewRect.height, self.view.frame.width, bottomControlsView.frame.origin.y - (headerViewRect.height))
        noResponseView.frame = noResponsesViewRect
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if let videoName = self.videoName {
            self.challengeImage.hidden = true
                prepareVideoAsset(NSURL(fileURLWithPath: ChallengeDataManipulationHelper.fileInDocumentsDirectory(videoName)))
        }
        //print("single challenge view will appear")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if let videoPlayer = self.videoPlayer {
            if !viewedResponse {
            videoPlayer.playVideo()
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let responses = self.responses {
            return responses.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("response", forIndexPath: indexPath) as! ResponseViewCell
        //let image = UIImage(contentsOfFile: ChallengeDataManipulationHelper.fileInDocumentsDirectory(challenge.imageLocation!))
        
        cell.label.text = responses![indexPath.row].title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("viewResponseSegue", sender: nil)
    }
    
    private func setupCameraController() {
        dataSaveHelper = DataSaveHelper(moc: (dataController?.managedObjectContext)!)
        self.cameraController = CameraController(
            dismissalHandler: { picker in
                self.dismissViewControllerAnimated(false, completion: {
                    picker.dismissViewControllerAnimated(true, completion: {})
                })
            }, presentCameraHandler: {
                self.presentViewController(self.cameraController!.imagePicker, animated: true, completion: {
                })
            }, dismissCameraWithPicture: { image in
                print(image)
                self.saveResponseWithPicture(image)
                //self.challengeCreationController?.challengeImage = image
            }, dismissCameraWithVideo: { videoURL in
                self.saveResponseWithVideo(videoURL)
                print(videoURL)
                //(self.challengeCreationController?.videoURL = videoURL)!
        })
    }
    
    @IBAction func addResponseButtonTouched(sender: UIButton) {
        let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("popoverViewController") as! PopoverViewController
        menuViewController.modalPresentationStyle = .Popover
        menuViewController.preferredContentSize = CGSizeMake(375, 70)
        
        menuViewController.leftButtonCallback = {
            print("left")
            self.dismissViewControllerAnimated(true, completion: nil)
            self.cameraController?.prepareToChooseFromLibrary()
            //
        }
        
        menuViewController.rightButtonCallback = {
            print("right")
            self.dismissViewControllerAnimated(true, completion: nil)
            self.cameraController?.prepareForCapture()
        }
        
        let popoverMenuViewController = menuViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = sender
        popoverMenuViewController?.sourceRect = CGRect(x: sender.frame.origin.x/2, y: sender.frame.origin.y-sender.frame.height/2, width: 1,height: 1)
        presentViewController(menuViewController,animated: true, completion: nil)
    }
    
    private func saveResponseWithVideo(videoURL: NSURL){
        dataSaveHelper?.saveNewResponse(videoURL, image: ChallengeDataManipulationHelper.backgroundImageFromVideo(videoURL), challenge: self.challenge!, saveSuccess: {
            self.saveSuccessBlock!()
        })
    }
    
    
    @IBAction func descriptionButtonTouched(sender: UIButton) {
        
        let descriptionPopoverViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("descriptionPopoverViewController") as! DescriptionPopoverViewController
        descriptionPopoverViewController.modalPresentationStyle = .Popover
        descriptionPopoverViewController.preferredContentSize = CGSizeMake(240, 128)
        descriptionPopoverViewController.text = challenge?.challengeDescription
        let popoverMenuViewController = descriptionPopoverViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = sender
        popoverMenuViewController?.sourceRect = sender.frame //CGRect(x: sender.frame.origin.x/2, y: sender.frame.origin.y-sender.frame.height/2, width: 1,height: 1)
        presentViewController(descriptionPopoverViewController,animated: true, completion: nil)
    }
    
    private func saveResponseWithPicture(image: UIImage){
        dataSaveHelper?.saveNewResponse(nil, image: image, challenge: self.challenge!, saveSuccess: {
            self.saveSuccessBlock!()
        })
    }
    
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewResponseSegue" {
            let responseViewController = segue.destinationViewController as! ResponseViewController
            let response = responses![(tableView.indexPathForSelectedRow?.row)!]
            responseViewController.response = response
            self.tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: false)
            viewedResponse = true
        }
    }
    
    private func prepareVideoAsset(videoURL: NSURL) {
        
        videoPlayer = VideoPlayController()
        videoPlayer!.view.frame = videoPlayerView.bounds
        self.addChildViewController(videoPlayer!)
        videoPlayerView.addSubview(videoPlayer!.view)
        videoPlayer!.didMoveToParentViewController(self)
        videoPlayer!.prepareforVideo(AVAsset(URL: videoURL))
        
    }
    

}
