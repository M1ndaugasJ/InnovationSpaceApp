//
//  VideoPlayController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/15/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayController: UIViewController {

    var avPlayer = AVPlayer()
    var playerView = UIView()
    var playbackButton = UIButton()
    var imageViewForPlaybackButton = UIImageView()
    var timeRemainingLabel: UILabel = UILabel()
    var viewForControlBackground: UIView = UIView()
    var timeObserver: AnyObject!
    var avPlayerLayer: AVPlayerLayer!
    //var blurEffectView: UIVisualEffectView?
    var seekSlider: UISlider = UISlider()
    
    var playerRateBeforeSeek: Float = 0
    let controlsHeight: CGFloat = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.backgroundColor = UIColor.clearColor()
        viewForControlBackground.backgroundColor = UIColor.whiteColor()
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        
        playerView.layer.insertSublayer(avPlayerLayer, atIndex: 0)
        
        playbackButton.addTarget(self, action: "invisibleButtonTapped:",
            forControlEvents: UIControlEvents.TouchUpInside)
        
        timeRemainingLabel.textColor = UIColor.blackColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("playerItemDidReachEnd:"), name: AVPlayerItemDidPlayToEndTimeNotification, object: avPlayer.currentItem)
        
        let timeInterval: CMTime = CMTimeMakeWithSeconds(0.05, 60000)
        timeObserver = avPlayer.addPeriodicTimeObserverForInterval(timeInterval,
            queue: dispatch_get_main_queue()) { (elapsedTime: CMTime) -> Void in
                self.observeTime(elapsedTime)
        }
        
        seekSlider.addTarget(self, action: "sliderBeganTracking:",
            forControlEvents: UIControlEvents.TouchDown)
        seekSlider.addTarget(self, action: "sliderEndedTracking:",
            forControlEvents: [UIControlEvents.TouchUpInside, UIControlEvents.TouchUpOutside])
        seekSlider.addTarget(self, action: "sliderValueChanged:",
            forControlEvents: UIControlEvents.ValueChanged)
        
        seekSlider.continuous = true
        seekSlider.setThumbImage(emptySliderImage(), forState: .Normal)
        seekSlider.maximumTrackTintColor = UIColor.blackColor()
        seekSlider.minimumTrackTintColor = UIColor.peterRiver()
        
        imageViewForPlaybackButton.contentMode = .Center
        imageViewForPlaybackButton.alpha = 0
        
        //view.addSubview(blurEffectView!)
        view.addSubview(playerView)
        view.addSubview(playbackButton)
        view.addSubview(imageViewForPlaybackButton)
        view.addSubview(viewForControlBackground)
        view.addSubview(timeRemainingLabel)
        view.addSubview(seekSlider)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let controlsY: CGFloat = view.bounds.size.height - controlsHeight;
        
        playerView.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
        avPlayerLayer.frame = CGRectMake(playerView.frame.origin.x, playerView.frame.origin.y - controlsHeight, playerView.frame.size.width, playerView.frame.size.height)
        
        imageViewForPlaybackButton.frame = avPlayerLayer.frame
        playbackButton.frame = avPlayerLayer.bounds
        timeRemainingLabel.frame = CGRect(x: 5, y: controlsY, width: 60, height: controlsHeight)
        viewForControlBackground.frame = CGRectMake(view.bounds.origin.x, controlsY, view.bounds.size.width, controlsHeight)
        seekSlider.frame = CGRect(x: timeRemainingLabel.frame.origin.x + timeRemainingLabel.bounds.size.width,
            y: controlsY, width: view.bounds.size.width - timeRemainingLabel.bounds.size.width - 5, height: controlsHeight)
        
    }
    
    func prepareforVideo(asset: AVURLAsset){
        let playerItem = AVPlayerItem(asset: asset)
        avPlayer.replaceCurrentItemWithPlayerItem(playerItem)
        seekSlider.maximumValue = Float(asset.duration.seconds)
        avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.None
        avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        avPlayer.play()
    }
    
    func invisibleButtonTapped(sender: UIButton!) {
        let playerIsPlaying:Bool = avPlayer.rate > 0
        
        if (playerIsPlaying) {
            avPlayer.pause()
            imageViewForPlaybackButton.image = UIImage(named: "pause")
            animatePlayback()
        } else {
            avPlayer.play()
            imageViewForPlaybackButton.image = UIImage(named: "play")
            animatePlayback()
        }
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        let item = notification.object as! AVPlayerItem
        item.seekToTime(kCMTimeZero)
        avPlayer.pause()
    }
    
    private func updateTimeLabel(elapsedTime elapsedTime: Float64, duration: Float64) {
        let timeRemaining: Float64 = CMTimeGetSeconds(avPlayer.currentItem!.duration) - elapsedTime
        timeRemainingLabel.text = String(format: "%02d:%02d", ((lround(timeRemaining) / 60) % 60), lround(timeRemaining) % 60)
    }
    
    private func observeTime(elapsedTime: CMTime) {
        let duration = CMTimeGetSeconds(avPlayer.currentItem!.duration);
        if (isfinite(duration)) {
            let elapsedTimey = CMTimeGetSeconds(elapsedTime)
            updateTimeLabel(elapsedTime: elapsedTimey, duration: duration)
            
            seekSlider.setValue(Float(elapsedTimey), animated: true)
        }
    }
    
    func sliderBeganTracking(slider: UISlider!) {
        playerRateBeforeSeek = avPlayer.rate
        avPlayer.pause()
        
    }
    
    func sliderEndedTracking(slider: UISlider!) {
        print(slider.value)
        let videoDuration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
        let elapsedTime: Float64 = Double(slider.value)
        updateTimeLabel(elapsedTime: elapsedTime, duration: videoDuration)
        avPlayer.seekToTime(CMTimeMakeWithSeconds(elapsedTime, 60000)) { (completed: Bool) -> Void in
            if (self.playerRateBeforeSeek > 0) {
                self.avPlayer.play()
            }
        }
    }
    
    func sliderValueChanged(slider: UISlider!) {
        let videoDuration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
        let elapsedTime: Float64 = Double(slider.value)
        updateTimeLabel(elapsedTime: elapsedTime, duration: videoDuration)
    }
    
    private func emptySliderImage() -> UIImage {
        let rect = CGRectMake(0,0,1,1)
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(1,1), false, 0)
        UIColor.clearColor().setFill()
        UIRectFill(rect)
        let blankImg: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return blankImg
    }
    
    private func animatePlayback() {
        
        self.imageViewForPlaybackButton.fadeIn(0.4, delay: 0, completion: {
            finished in
            self.imageViewForPlaybackButton.fadeOut(0.4, delay: 0)
        })
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        avPlayer.removeTimeObserver(timeObserver)
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
