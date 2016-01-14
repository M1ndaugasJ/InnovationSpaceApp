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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func iWillTapped(sender: UIButton) {
        print("i will")
    }

}
