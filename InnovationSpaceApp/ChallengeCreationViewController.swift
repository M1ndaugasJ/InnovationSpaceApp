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

class ChallengeCreationViewController: UncoveredContentViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var controlsView: UIView!
    //@IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var descriptionButton: SideMenuButton!
    @IBOutlet weak var postButton: SideMenuButton!
    @IBOutlet weak var movingView: UIView!
    @IBOutlet weak var stayingView: UIView!
    @IBOutlet weak var movingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButtonWord: UIButton!
    
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
    
    var challengeDescriptionViewController: DescriptionViewController?
    var blurEffectView: UIVisualEffectView?
    var blurEffectViewTop: UIVisualEffectView?
    var checkCanPost: Bool = true
    var mainImageColor: UIColor?
    let colorView = UIView()
    
    enum AppError : ErrorType {
        case InvalidResource(String)
    }
    
    var videoURL: NSURL? {
        didSet{
            do {
                try playVideo()
                imageView.hidden = true
            } catch AppError.InvalidResource(let name) {
                debugPrint("Could not find resource \(name).")
            } catch {
                debugPrint("Generic error")
            }
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
            mainImageColor = backgroundImage?.getColors().backgroundColor
            imageView.contentMode = .ScaleToFill
            imageView.frame = colorView.bounds
            colorView.addSubview(imageView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        let blurEffectTop = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        blurEffectViewTop = UIVisualEffectView(effect: blurEffectTop)
        
        //self.view.translatesAutoresizingMaskIntoConstraints = true
        
//        titleTextField.borderStyle = .None
//        titleTextField.addBorder(edges: [.Bottom, .Top], colour: UIColor.lightGrayColor(), thickness: 0.5)
        titleTextField.autocorrectionType = .No
        titleTextField.addTarget(self, action: "titleValueHasChanged:", forControlEvents: .EditingChanged)
        
        //hideKeyboardButton.layer.cornerRadius = 6
        //enabledButtonStyle(closeButtonWord)
        closeButtonWord.enableButtonStyleNoBackground()
        closeButtonWord.layer.borderColor = UIColor.whiteColor().CGColor
        
        //descriptionButton.layer.cornerRadius = 6
        //buttonEnabled(descriptionButton)
        descriptionButton.enableButtonStyleNoBackground()

        postButton.layer.cornerRadius = 6
        postButton.layer.borderWidth = 1.5
        postButton.disabledButtonStyle()
        //buttonDisabled(postButton)
        
        controlsView.addBorder(edges: [.Top], colour: UIColor.lightGrayColor(), thickness: 0.5)
        
        self.viewToMove = self.view
        self.viewToMoveBottomConstraint = self.movingViewBottomConstraint
        
        hideButtonEnableCallback = {
            //self.titleTextField.buttonHideKeyboard?.hidden = false
            self.titleTextField.buttonHideKeyboard?.setTitle("Done", forState: .Normal)
        }
        
        movingView.insertSubview(colorView, atIndex: 0)
        movingView.insertSubview(blurEffectView!, atIndex: 1)
        // Do any additional setup after loading the view.
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
            if (enteredText as String).length > 0 {
                self.descriptionButton.enabledButtonActionPerformedStyle()
            } else {
                self.descriptionButton.enableButtonStyleNoBackground()
            }
            
        }
        self.presentViewController(descriptionViewController, animated: true, completion: {})
//        let descriptionView = UIView(frame: CGRectMake(0, -self.view.frame.origin.y, self.view.frame.width, self.view.frame.height-titleTextField.frame.height-controlsView.frame.height))
//        descriptionView.backgroundColor = UIColor.blackColor()
//        self.view.addSubview(descriptionView)
//        self.view.frame.origin.y -= descriptionView.frame.height
//        descriptionView.frame.origin.y += self.view.frame.height-titleTextField.frame.height-controlsView.frame.height
    }
    
    
    private func playVideo() throws {
        guard NSFileManager.defaultManager().fileExistsAtPath((videoURL?.relativePath!)!) else {
            throw AppError.InvalidResource("shit")
        }
        let videoPlayer = VideoPlayController()
        videoPlayer.view.frame = videoPlayerView.bounds
        self.addChildViewController(videoPlayer)
        videoPlayerView.addSubview(videoPlayer.view)
        videoPlayer.didMoveToParentViewController(self)
        let asset = AVURLAsset(URL: videoURL!)
        backgroundImage = backgroundImageFromVideo(asset)
        videoPlayer.prepareforVideo(asset)
    }
    
    private func backgroundImageFromVideo(asset: AVURLAsset) -> UIImage? {
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        do {
            let image = try UIImage(CGImage: imageGenerator.copyCGImageAtTime(CMTime(seconds: 0, preferredTimescale: 1), actualTime: nil))
            return image
        } catch {
            print("Couldn't get the first frame")
            return nil
        }
    }
    
    @IBAction func closeButtonTouchDown(sender: UIButton) {
        view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    func closeButtonTouchUpInside(sender: UIButton) {
//        
//        closeButton.fadeOut(0.05, delay: 0, completion: {
//            finished in
//
//        })
//    }
//    
//    func closeButtonTouchDown(sender: UIButton) {
//        
//        closeButton.fadeOut(0.05, delay: 0, completion: {
//            finished in
//            self.closeButton.fadeIn(0.05, delay: 0)
//        })
//    }
    
    func titleValueHasChanged(sender: UITextField) {
        guard sender.text?.length >= 1 else {
            if checkCanPost {
                postButton.disabledButtonStyle()
                //buttonDisabled(postButton)
                checkCanPost = false
            }
            return
        }
        postButton.enabledButtonStyle()
        //buttonEnabled(postButton)
        checkCanPost = true
    }
    
//    private func buttonDisabled(button: UIButton){
//        button.backgroundColor = UIColor.whiteColor()
//        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
//        button.layer.borderColor = UIColor.lightGrayColor().CGColor
//        button.enabled = false
//        button.alpha = 0.5
//    }
    
    private func buttonEnabled(button: UIButton){
        button.enabled = true
        button.enabledButtonStyle()
        //enabledButtonStyle(button)
        
    }
    
//    private func enabledButtonStyle(button: UIButton){
//        button.layer.cornerRadius = 6
//        button.backgroundColor = UIColor.peterRiver()
//        button.layer.borderColor = UIColor.peterRiver().CGColor
//        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//        button.clipsToBounds = true
//        button.alpha = 1
//        button.layer.borderWidth = 1.5
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

