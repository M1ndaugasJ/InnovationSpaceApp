//
//  AddChallengeView.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/20/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//

import UIKit

typealias AddChallengeViewRightButtonCallback = () -> Void
typealias AddChallengeViewLeftButtonCallback = () -> Void

class AddChallengeView: UIView {

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet var contentView: UIView?
    
    var rightButtonCallback: AddChallengeViewRightButtonCallback?
    var leftButtonCallback: AddChallengeViewLeftButtonCallback?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        NSBundle.mainBundle().loadNibNamed("AddChallengeView", owner: self, options: nil)
        guard let content = contentView else { return }
        
        //content.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        self.frame = content.frame
        self.bounds = content.bounds
        self.addSubview(content)
        leftButton.enableButtonStyleNoBackground()
        rightButton.enableButtonStyleNoBackground()
    }
    
    @IBAction func rightButtonTouchedUpInside(sender: UIButton) {
        rightButtonCallback!()
    }
    
    @IBAction func leftButtonTouchedUpInside(sender: UIButton) {
        leftButtonCallback!()
    }

}
