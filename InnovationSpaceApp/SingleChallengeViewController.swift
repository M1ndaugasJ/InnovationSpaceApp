//
//  SingleChallengeViewController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 12/18/15.
//  Copyright © 2015 Mindaugas. All rights reserved.
//

import UIKit

class SingleChallengeViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var visualEffectViewBackground: UIVisualEffectView!
    @IBOutlet weak var challengeImage: UIImageView!
    @IBOutlet weak var imageViewForBackground: UIImageView!
    
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
        self.challengeImage.image = UIImage(contentsOfFile: ChallengeDataManipulationHelper.fileInDocumentsDirectory(challengeImageName!))
        self.imageViewForBackground.image = self.challengeImage.image
        challengeImage.transitionImageViewProperties()
        print("challenge image frame at veiw controller \(challengeImage.frame)")
        self.name.text = challengeName
        
        
        //insertBlurView(maskView, style: UIBlurEffectStyle.Light)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        print("single challenge view will appear")
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
