//
//  ChallengeCreationViewController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/14/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import CoreData

class ChallengeCreationViewController: UncoveredContentViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var descriptionButton: SideMenuButton!
    @IBOutlet weak var postButton: SideMenuButton!
    @IBOutlet weak var movingView: UIView!
    @IBOutlet weak var stayingView: UIView!
    @IBOutlet weak var movingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButtonWord: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var titleTextField: TextFieldWithInset! {
        
        didSet {
            titleTextField.callbackButtonPressed = {
                guard self.titleTextField.buttonHideKeyboard?.titleLabel?.text == "Done" else {
                    self.titleTextField.becomeFirstResponder()
                    return
                }
                self.view.endEditing(true)
                self.titleTextField.buttonHideKeyboard?.setTitle("Show", forState: .Normal)
            }
        }
        
    }
    
    var savedChallengeCallback: (()->Void)?
    var descriptionText: String = ""
    
    var challengeDescriptionViewController: DescriptionViewController?
    var blurEffectView: UIVisualEffectView?
    var blurEffectViewTop: UIVisualEffectView?
    var checkCanPost: Bool = true
    var mainImageColor: UIColor?
    let dateFormat = "hh:mm:ss_yyyy-MM-dd"
    
    let colorView = UIView()
    var messageFrame = UIView()
    var activityIndicatorEmbbeded = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    enum AppError : ErrorType {
        case InvalidResource(String)
    }
    
    var videoURL: String? {
        didSet{
            do {
                try prepareVideoAsset()
                imageView.hidden = true
            } catch AppError.InvalidResource(let name) {
                debugPrint("Could not find resource \(name).")
            } catch {
                debugPrint("Generic error")
            }
        }
    }
    
    var challengeImageName: String? {
        didSet{
            challengeImage = UIImage(contentsOfFile: ChallengeDataManipulationHelper.fileInDocumentsDirectory(challengeImageName!))
        }
    }
    
    var challengeImage: UIImage? {
        didSet{
            imageView.image = challengeImage
            backgroundImage = challengeImage
            videoPlayerView.hidden = true
        }
    }
    
    var backgroundImage: UIImage? {
        didSet {
            let imageView = UIImageView(image: backgroundImage)
            imageView.contentMode = .ScaleToFill
            imageView.frame = colorView.bounds
            colorView.addSubview(imageView)
        }
    }
    
    var dimmingView: UIView? {
        didSet{
            dimmingView!.backgroundColor = UIColor(red: 200/255.0, green: 199/255.0, blue: 204/255.0, alpha: 0.5)
            dimmingView!.alpha = 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        let blurEffectTop = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        blurEffectViewTop = UIVisualEffectView(effect: blurEffectTop)
        
        activityIndicator.hidden = true
        
        dimmingView = UIView(frame: self.view.bounds)
        
        dimmingView?.hidden = true
        self.view.insertSubview(dimmingView!, belowSubview: activityIndicator!)
        
        titleTextField.autocorrectionType = .No
        titleTextField.addTarget(self, action: "titleValueHasChanged:", forControlEvents: .EditingChanged)
        
        closeButtonWord.enableButtonStyleNoBackground()
        closeButtonWord.layer.borderColor = UIColor.whiteColor().CGColor
        
        descriptionButton.enableButtonStyleNoBackground()

        postButton.layer.cornerRadius = 6
        postButton.layer.borderWidth = 1.5
        postButton.disabledButtonStyle()
        
        controlsView.addBorder(edges: [.Top], colour: UIColor.lightGrayColor(), thickness: 0.5)
        
        self.viewToMove = self.view
        self.viewToMoveBottomConstraint = self.movingViewBottomConstraint
        
        hideButtonEnableCallback = {
            self.titleTextField.buttonHideKeyboard?.setTitle("Done", forState: .Normal)
        }
        
        movingView.insertSubview(colorView, atIndex: 0)
        movingView.insertSubview(blurEffectView!, atIndex: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        blurEffectView?.frame = self.view.bounds
        blurEffectViewTop?.frame = stayingView.bounds
        colorView.frame = self.view.bounds
    }
    
    @IBAction func descriptionButtonTouchedDown(sender: UIButton) {
        self.challengeDescriptionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("challengeDescriptionViewController") as? DescriptionViewController
        
        guard let descriptionViewController = self.challengeDescriptionViewController else {
            return
        }
        
        descriptionViewController.descriptionButtonCallback = {
            enteredText in
            if (enteredText as String).characters.count > 0 {
                
                self.descriptionText = enteredText
                self.descriptionButton.enabledButtonActionPerformedStyle()
            } else {
                self.descriptionButton.enableButtonStyleNoBackground()
            }
            
        }
        self.presentViewController(descriptionViewController, animated: true, completion: {})
    }
    
    
    private func prepareVideoAsset() throws {
        
        guard NSFileManager.defaultManager().fileExistsAtPath((ChallengeDataManipulationHelper.fileInDocumentsDirectory(videoURL!))) else {
            throw AppError.InvalidResource("shit")
        }
        
        let videoPlayer = VideoPlayController()
        videoPlayer.view.frame = videoPlayerView.bounds
        self.addChildViewController(videoPlayer)
        videoPlayerView.addSubview(videoPlayer.view)
        videoPlayer.didMoveToParentViewController(self)
        
        let asset = AVAsset(URL: NSURL(fileURLWithPath: ChallengeDataManipulationHelper.fileInDocumentsDirectory(videoURL!)))
        backgroundImage = ChallengeDataManipulationHelper.backgroundImageFromVideo(asset)
        videoPlayer.prepareforVideo(asset)
        
    }
    
    @IBAction func closeButtonTouchDown(sender: UIButton) {
        view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func titleValueHasChanged(sender: UITextField) {
        guard sender.text?.characters.count >= 1 else {
            if checkCanPost {
                postButton.disabledButtonStyle()
                //buttonDisabled(postButton)
                checkCanPost = false
            }
            return
        }
        postButton.enabledButtonStyle()
        checkCanPost = true
    }
    
    private func buttonEnabled(button: UIButton){
        button.enabled = true
        button.enabledButtonStyle()
        //enabledButtonStyle(button)
        
    }
    
//    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
//        print(msg)
//        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
//        strLabel.text = msg
//        strLabel.textColor = UIColor.whiteColor()
//        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
//        messageFrame.layer.cornerRadius = 15
//        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
//        if indicator {
//            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
//            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//            activityIndicator.startAnimating()
//            messageFrame.addSubview(activityIndicator)
//        }
//        messageFrame.addSubview(strLabel)
//        view.addSubview(messageFrame)
//    }

    
    @IBAction func postButtonTouchedInside(sender: UIButton) {
        
        //progressBarDisplayer("Saving Your Challenge", true)
        activityIndicator.hidden = false
        dimmingView?.hidden = false
        activityIndicator.startAnimating()
        self.resignFirstResponder()
        dispatch_async(dispatch_get_main_queue(), {
            self.saveData()
            dispatch_async(dispatch_get_main_queue(), {
                self.activityIndicator.hidden = true
                self.dimmingView?.hidden = true
                //self.messageFrame.removeFromSuperview()
                self.savedChallengeCallback!()
                self.dismissViewControllerAnimated(true, completion: {})
            })
        })
        
        
    }
    
    private func saveData(){
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = dateFormat
        let fileName = "\(formatter.stringFromDate(date)).PNG"
        let imagePath = ChallengeDataManipulationHelper.fileInDocumentsDirectory(fileName)
        let data = UIImageJPEGRepresentation(challengeImage!, 0.75)
        
        data?.writeToFile(imagePath, atomically: true)
        
        print(titleTextField.text)
        print(descriptionText)
        print(videoURL)
        print(imagePath)
        let dataController = DataController()
        let moc = dataController.managedObjectContext
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Challenge", inManagedObjectContext: moc) as! Challenge
        
        entity.setValue(titleTextField.text, forKey: "challengeTitle")
        entity.setValue(descriptionText, forKey: "challengeDescription")
        entity.setValue(fileName, forKey: "imageLocation")
        
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }

}

