//
//  SingleChallengeViewController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 12/18/15.
//  Copyright © 2015 Mindaugas. All rights reserved.
//

import UIKit
import AVFoundation

class SingleChallengeViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var visualEffectViewBackground: UIVisualEffectView!
    @IBOutlet weak var challengeImage: UIImageView!
    @IBOutlet weak var imageViewForBackground: UIImageView!
    @IBOutlet weak var videoPlayerView: UIView!
    
    var challengeName: String?
    var videoName: String?
    var challengeImageName: String?
    var videoPlayer: VideoPlayController?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(challengeName: String, challengeImageName: String){
        super.init(nibName: nil, bundle: nil)
        self.challengeName = challengeName
        self.challengeImageName = challengeImageName
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(contentsOfFile: ChallengeDataManipulationHelper.fileInDocumentsDirectory(challengeImageName!))
        
        self.challengeImage.image = image
        challengeImage.transitionImageViewProperties()
        self.imageViewForBackground.image = image
        
        //print("challenge image frame at veiw controller \(challengeImage.frame)")
        self.name.text = challengeName
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if let videoName = self.videoName {
            self.challengeImage.hidden = true
            prepareVideoAsset(NSURL(fileURLWithPath: ChallengeDataManipulationHelper.fileInDocumentsDirectory(videoName)))
        }
        print("single challenge view will appear")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if let videoPlayer = self.videoPlayer {
            videoPlayer.playVideo()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //let challengeLoadedImage = UIImage(named: challengeImageName!)
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
    
    @IBAction func iWillTapped(sender: UIButton) {
        print("i will")
    }

}
