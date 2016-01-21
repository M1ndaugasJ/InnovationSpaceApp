//
//  ChallengeDataManipulationHelper.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/22/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ChallengeDataManipulationHelper: NSObject {

    class func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    
    class func fileInDocumentsDirectory(filename: String) -> String {
        
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
        
    }
    
    class func backgroundImageFromVideo(asset: AVAsset) -> UIImage? {
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
    
    class func saveToPathInDocumentsDirectory(path: String, data: NSData){
        
    }
    
}
