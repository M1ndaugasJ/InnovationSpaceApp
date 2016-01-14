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

typealias DismissCamera = (imagePicker: UIImagePickerController) -> Void
typealias PresentCamera = () -> Void
typealias DismissCameraWithData = (image: UIImage) -> Void

class CameraController: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let dismissalHandler: DismissCamera?
    let presentCameraHandler: PresentCamera?
    let dismissCameraWithData: DismissCameraWithData?

    init(dismissalHandler: DismissCamera, presentCameraHandler: PresentCamera, dismissCameraWithData: DismissCameraWithData) {
        self.dismissalHandler = dismissalHandler
        self.presentCameraHandler = presentCameraHandler
        self.dismissCameraWithData = dismissCameraWithData
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
                //postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
            }
        } else {
            //postAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    
    func prepareToChooseFromLibrary(){
        if (UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum)) {
            imagePicker.allowsEditing = false //2
            imagePicker.sourceType = .SavedPhotosAlbum //3
            imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
            self.presentCameraHandler!()
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
            print("Got an image")
            self.dismissCameraWithData!(image: image)
//            let selectorToCall = Selector("imageWasSavedSuccessfully:didFinishSavingWithError:context:")
//            UIImageWriteToSavedPhotosAlbum(image, self, selectorToCall, nil)
            //dismissCameraWithData!()
        }
        
        if let videoURL:NSURL = (info[UIImagePickerControllerMediaURL]) as? NSURL {
            print("Got a video")
//            let selectorToCall = Selector("videoWasSavedSuccessfully:didFinishSavingWithError:context:")
//            UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath!, self, selectorToCall, nil)
            //dismissCameraWithData!()
            
        }
        
        imagePicker.dismissViewControllerAnimated(true, completion: {
            
            // Anything you want to happen when the user saves an image
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User cancelled image picker")
        dismissalHandler!(imagePicker: imagePicker)
//        dismissViewControllerAnimated(true, completion: {
//            // Anything you want to happen when the user selects cancel
//        })
    }
    
    func imageWasSavedSuccessfully(image: UIImage, didFinishSavingWithError error: NSError!, context: UnsafeMutablePointer<()>){
        print("Image saved")
        if let theError = error {
            print("An error happened while saving the image = \(theError)")
        } else {
            print("Displaying")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //self.currentImage.image = image
            })
        }
    }
    
    func videoWasSavedSuccessfully(videoPath: String, didFinishSavingWithError error: NSError!, context: UnsafeMutablePointer<()>){
        print("Video saved")
        if let theError = error {
            print("An error happened while saving the video = \(theError)")
        } else {
            print("Displaying")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //self.currentImage.image = image
            })
        }
    }

    
}
