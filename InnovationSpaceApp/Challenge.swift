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
    let photoName: String?
    
    init(name: String, photo: String){
        self.name = name
        self.photoName = photo
    }
    
}
