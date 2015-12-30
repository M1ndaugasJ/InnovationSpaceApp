//
//  SingleChallengeViewController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 12/18/15.
//  Copyright © 2015 Mindaugas. All rights reserved.
//

import UIKit
import Spring

class SingleChallengeViewController: UIViewController {
    
    @IBOutlet weak var challengeBackgroundImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var challengeImage: UIImageView!
    
    var challengeName: String?
    
    var challengeImageName: String?
    
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
        challengeImage.contentMode = .ScaleAspectFit
        self.name.text = challengeName
        self.challengeImage.image = UIImage(named: challengeImageName!)
        let challengeLoadedImage = UIImage(named: challengeImageName!)
        self.challengeBackgroundImage.image = challengeLoadedImage
        
        //insertBlurView(maskView, style: UIBlurEffectStyle.Light)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //let challengeLoadedImage = UIImage(named: challengeImageName!)
    }
    
//    func calculateClientRectOfImageInUIImageView(imgView: UIImageView) -> CGRect
//    {
//        let imgViewSize = imgView.frame.size                  // Size of UIImageView
//        var imgSize = imgView.image!.size                  // Size of the image, currently displayed
//
//        // Calculate the aspect, assuming imgView.contentMode==UIViewContentModeScaleAspectFit
//
//        let scaleW = imgViewSize.width / imgSize.width
//        let scaleH = imgViewSize.height / imgSize.height
//        let aspect = fmin(scaleW, scaleH);
//
//        imgSize.width = imgSize.width * aspect
//        imgSize.height = imgSize.height * aspect
//            
//        var imageRect = CGRectMake(0,0,imgSize.width,imgSize.height)
//
//        // Note: the above is the same as :
//        // CGRect imageRect=CGRectMake(0,0,imgSize.width*=aspect,imgSize.height*=aspect) I just like this notation better
//
//        // Center image
//
//        imageRect.origin.x=(imgViewSize.width-imageRect.size.width)/2
//        imageRect.origin.y = 0
//
//        // Add imageView offset
//
//        imageRect.origin.x+=imgView.frame.origin.x
//        imageRect.origin.y+=imgView.frame.origin.y
//
//        return imageRect
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func iWillTapped(sender: UIButton) {
        print("i will")
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
