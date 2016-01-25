//
//  ResponseViewController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/24/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//

import UIKit
import AVFoundation

class ResponseViewController: UIViewController {

    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var challengeImageView: UIImageView!
    @IBOutlet weak var videoPlayerView: UIView!
    
    var response: Response?
    var responseTitle: String?
    //var videoName: String?
    var videoPlayer: VideoPlayController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(response?.responseImageFileName)
        print(response?.responseVideoFileName)
        print(NSFileManager.defaultManager().fileExistsAtPath(ChallengeDataManipulationHelper.fileInDocumentsDirectory(response!.responseImageFileName!)))
        
        let image = UIImage(contentsOfFile: ChallengeDataManipulationHelper.fileInDocumentsDirectory(response!.responseImageFileName!))
        
        self.challengeImageView.image = image
        self.backGroundImageView.image = image
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if let videoName = response!.responseVideoFileName {
            self.challengeImageView.hidden = true
            prepareVideoAsset(NSURL(fileURLWithPath: ChallengeDataManipulationHelper.fileInDocumentsDirectory(videoName)))
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if let videoPlayer = self.videoPlayer {
            videoPlayer.playVideo()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareVideoAsset(videoURL: NSURL) {
        
        videoPlayer = VideoPlayController()
        videoPlayer!.view.frame = videoPlayerView.bounds
        self.addChildViewController(videoPlayer!)
        videoPlayerView.addSubview(videoPlayer!.view)
        videoPlayer!.didMoveToParentViewController(self)
        videoPlayer!.prepareforVideo(AVAsset(URL: videoURL))
        
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
