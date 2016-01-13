//
//  CameraController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/13/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//

import UIKit
typealias DismissCamera = () -> Void
typealias PresentCamera = () -> Void

class CameraController: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let dismissalHandler: DismissCamera?
    let presentCameraHandler: PresentCamera?

    init(dismissalHandler: DismissCamera, presentCameraHandler: PresentCamera) {
        self.dismissalHandler = dismissalHandler
        self.presentCameraHandler = presentCameraHandler
        super.init()
        imagePicker.delegate = self
        print("class initialized")
    }
    
    func prepareForCapture(captureMode : UIImagePickerControllerCameraCaptureMode){
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                imagePicker.cameraCaptureMode = .Photo
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentCameraHandler!()
                })
            } else {
                //postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
            }
        } else {
            //postAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Got an image")
        if let pickedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
            //let selectorToCall = Selector("imageWasSavedSuccessfully:didFinishSavingWithError:context:")
            //UIImageWriteToSavedPhotosAlbum(pickedImage, self, selectorToCall, nil)
        }
        
        imagePicker.dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user saves an image
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User canceled image")
        dismissalHandler!()
//        dismissViewControllerAnimated(true, completion: {
//            // Anything you want to happen when the user selects cancel
//        })
    }

    
}
