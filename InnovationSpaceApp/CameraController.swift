//
//  CameraController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/13/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//

import UIKit
import MobileCoreServices
import AssetsLibrary
import CoreData
import Photos

typealias DismissCamera = (imagePicker: UIImagePickerController) -> Void
typealias PresentCamera = () -> Void
typealias DismissCameraWithPicture = (image: UIImage) -> Void
typealias DismissCameraWithVideo = (videoURL: NSURL) -> Void

class CameraController: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicker: UIImagePickerController! = UIImagePickerController()
    let dismissalHandler: DismissCamera?
    let presentCameraHandler: PresentCamera?
    let dismissCameraWithPicture: DismissCameraWithPicture?
    let dismissCameraWithVideo: DismissCameraWithVideo?
    
    var lastChallengeID: NSManagedObjectID?

    init(dismissalHandler: DismissCamera, presentCameraHandler: PresentCamera, dismissCameraWithPicture: DismissCameraWithPicture, dismissCameraWithVideo: DismissCameraWithVideo) {
        self.dismissalHandler = dismissalHandler
        self.presentCameraHandler = presentCameraHandler
        self.dismissCameraWithPicture = dismissCameraWithPicture
        self.dismissCameraWithVideo = dismissCameraWithVideo
        super.init()
        imagePicker.delegate = self
        print("class initialized")
    }
    
    func prepareForCapture(){
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                imagePicker.sourceType = .Camera
                imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
                imagePicker.videoMaximumDuration = 10.0
                self.presentCameraHandler!()
            } else {
                print("Rear camera doesn't exist")
                //postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
            }
        } else {
            print("Camera inaccessible")
            //postAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    
    func prepareToChooseFromLibrary(){
        if (UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)) {
            imagePicker.allowsEditing = false //2
            imagePicker.sourceType = .SavedPhotosAlbum //3
            imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
            self.presentCameraHandler!()
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
//        let date = NSDate()
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = dateFormat
        
        if let image:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
//            let fileName = "\(formatter.stringFromDate(date)).PNG"
//            let imagePath = ChallengeDataManipulationHelper.fileInDocumentsDirectory(fileName)
//            let data = UIImagePNGRepresentation(image)
//            data?.writeToFile(imagePath, atomically: true)
            self.dismissCameraWithPicture!(image: image)
        }
        
        if let videoURL:NSURL = (info[UIImagePickerControllerMediaURL]) as? NSURL {

            self.dismissCameraWithVideo!(videoURL: videoURL)
        }
        
        imagePicker.dismissViewControllerAnimated(true, completion: {
            
            // Smh
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User cancelled image picker")
        dismissalHandler!(imagePicker: imagePicker)
    }
    
    deinit {
        imagePicker = nil
    }
    
}
