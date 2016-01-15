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

class ChallengeCreationViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    var blurEffectView: UIVisualEffectView?
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
            imageView.contentMode = .ScaleToFill
            imageView.frame = colorView.bounds
            colorView.addSubview(imageView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.view.insertSubview(colorView, atIndex: 0)
        self.view.insertSubview(blurEffectView!, atIndex: 1)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        blurEffectView?.frame = self.view.bounds
        colorView.frame = self.view.bounds
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
    
    @IBAction func closeButtonTouched(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {})
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
