//
//  DataSaveHelper.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/24/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//

import UIKit
import CoreData

class DataSaveHelper: NSObject {

    let dateFormat = "hh:mm:ss_yyyy-MM-dd"
    var date = NSDate()
    let formatter = NSDateFormatter()
    var moc: NSManagedObjectContext?
    
    init(moc: NSManagedObjectContext){
        self.moc = moc
    }
    
    func fileName(fileExtension: String, stringToAppend: String?) -> String {
        date = NSDate()
        formatter.dateFormat = dateFormat
        if let stringToAppend = stringToAppend {
            return "\(stringToAppend)\(formatter.stringFromDate(date))\(fileExtension)"
        } else {
            let fileNameString = "\(formatter.stringFromDate(date))\(fileExtension)"
            print("saved with name \(fileNameString)")
            return fileNameString
        }
    }
    
    func saveVideo(videoURL: NSURL) -> String {
        let videoData = NSData(contentsOfURL: videoURL)
        let videoFileName = fileName(".mov", stringToAppend: nil)
        let videoPath = ChallengeDataManipulationHelper.fileInDocumentsDirectory(videoFileName)
        videoData?.writeToFile(videoPath, atomically: true)
        return videoFileName
    }
    
    func saveImageWithData(image: UIImage, compressionRatio: CGFloat) -> String {
        let imageName = fileName(".png", stringToAppend: nil)
        let imagePath = ChallengeDataManipulationHelper.fileInDocumentsDirectory(imageName)
        let data = UIImageJPEGRepresentation(image, compressionRatio)
        data?.writeToFile(imagePath, atomically: true)
        return imageName
    }
    
    func saveNewChallenge(challengeTitle: String, challengeDescription: String?, videoURL: NSURL?, challengeImage: UIImage?){
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Challenge", inManagedObjectContext: moc!) as! Challenge
        entity.setValue(challengeTitle, forKey: "challengeTitle")
        entity.setValue(challengeDescription, forKey: "challengeDescription")
        
        if let videoURL = videoURL {
            let videoName = saveVideo(videoURL)
            let imageName = saveImageWithData(ChallengeDataManipulationHelper.backgroundImageFromVideo(videoURL)!, compressionRatio: 0.75)
            
            entity.setValue(imageName, forKey: "imageLocation")
            entity.setValue(videoName, forKey: "videoLocation")
        }
        if let challengeImage = challengeImage {
            let imageName = saveImageWithData(challengeImage, compressionRatio: 0.75)
            entity.setValue(imageName, forKey: "imageLocation")
        }
        
        do {
            try moc!.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
    }
    
    func saveNewResponse(videoURL: NSURL?, image: UIImage?, challenge: Challenge, saveSuccess: () -> Void) {
        let response = NSEntityDescription.insertNewObjectForEntityForName("Response", inManagedObjectContext: moc!) as! Response
        
        response.challenge = challenge
        
        if let videoURL = videoURL {
            response.responseVideoFileName = saveVideo(videoURL)
            response.responseImageFileName = saveImageWithData(image!, compressionRatio: 0.75)
            response.title = "User added a video response"
        } else if let image = image {
            response.responseImageFileName = saveImageWithData(image, compressionRatio: 0.75)
            response.title = "User added a photo response"
        }
        
        do {
            try moc!.save()
            saveSuccess()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
    }
    
//    func saveImageWithPath(){
//        let fileName = "\(formatter.stringFromDate(date)).PNG"
//        let imagePath = ChallengeDataManipulationHelper.fileInDocumentsDirectory(fileName)
//        let data = UIImageJPEGRepresentation(challengeImage, 0.75)
//        
//        data?.writeToFile(imagePath, atomically: true)
//    }
    
}
