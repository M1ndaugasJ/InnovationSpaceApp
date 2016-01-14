//
//  Challenge.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 12/7/15.
//  Copyright © 2015 Mindaugas. All rights reserved.
//

import UIKit

class Challenge: NSObject {
    let name: String?
    var photoName: String?
    var videoURL: NSURL?
    var image: UIImage?
    
    init(name: String, photo: String){
        self.name = name
        self.photoName = photo
    }
    
    init(name: String, videoURL: NSURL){
        self.name = name
        self.videoURL = videoURL
    }
    
    init(name: String, image: UIImage){
        self.name = name
        self.image = image
    }
    
}
