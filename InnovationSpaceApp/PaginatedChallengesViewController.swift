//
//  PaginatedChallengesViewController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 12/28/15.
//  Copyright © 2015 Mindaugas. All rights reserved.
//

import UIKit
import Spring

class PaginatedChallengesViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var addChallengeView: UIView!
    @IBOutlet weak var dimmingView: UIView! {
        didSet{
            dimmingView.backgroundColor = UIColor(red: 200/255.0, green: 199/255.0, blue: 204/255.0, alpha: 0.5)
            dimmingView.alpha = 0.0
        }
    }
    
    var pageImages: [Challenge] = []
    var pageViews: [SingleChallengeViewController?] = []
    var addChallengeButtonImageView: UIImageView?
    var addChallengesBarButtonItem: UIBarButtonItem?
    var cameraController: CameraController?
    var isAddChallengesOpen = false
    var challengeCreationController: ChallengeCreationViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;
        self.scrollView.contentInset = UIEdgeInsetsMake(0,0,0,0);
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.bounces = true
        
        self.navigationController?.topViewController?.title = "Challenges"
        addChallengeButtonImageView = UIImageView(image: UIImage(named: "addpng"))
        addChallengeButtonImageView?.autoresizingMask = .None
        addChallengeButtonImageView?.contentMode = .Center
        
        let button = UIButton(type: .Custom)
        button.frame = CGRectMake(0, 0, 40, 40)
        button.addSubview(addChallengeButtonImageView!)
        button.addTarget(self, action: Selector("btnOpenAddView"), forControlEvents: .TouchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self, action: "dimmingViewTouched:")
        dimmingView.addGestureRecognizer(gesture)
        
        addChallengeButtonImageView?.center = button.center
        addChallengesBarButtonItem = UIBarButtonItem(customView: button)
        
        let globalPoint = button.convertPoint(button.frame.origin, toView: nil)
        print(globalPoint)
        
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = addChallengesBarButtonItem
        
        self.cameraController = CameraController(dismissalHandler: { picker in
                self.dismissViewControllerAnimated(false, completion: {
                    picker.dismissViewControllerAnimated(true, completion: {})
                })
            }, presentCameraHandler: {
                self.challengeCreationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("challengeCreationViewController") as? ChallengeCreationViewController
                
                self.challengeCreationController!.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
                self.presentViewController(self.challengeCreationController!, animated: false, completion: {})
                self.challengeCreationController!.view.alpha = 0
                
                self.presentViewController(self.cameraController!.imagePicker, animated: true, completion: {
                    self.challengeCreationController!.view.alpha = 1
                })
                
                self.challengeCreationController!.modalPresentationStyle = UIModalPresentationStyle.FullScreen
                
                self.btnOpenAddView()
            }, dismissCameraWithPicture: { image in
                self.challengeCreationController?.challengeImage = image
            }, dismissCameraWithVideo: { videoURL in
                self.challengeCreationController?.videoURL = videoURL
            })
        
        pageImages = [Challenge(name: "skiing", photo: "photo1"), Challenge(name: "flying", photo: "photo2"), Challenge(name: "deving", photo: "photo3")]
        let pageCount = pageImages.count
        
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // Set up the content size of the scroll view
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(pageImages.count), pagesScrollViewSize.height)
        
        // Load the initial set of pages that are on screen
        loadVisiblePages()
    }
    
    func loadVisiblePages() {
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        //pageControl.currentPage = page
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }
    
    func loadPage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Load an individual page, first checking if you've already loaded it
        if let _ = pageViews[page] {
            // Do nothing. The view is already loaded.
        } else {
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            //frame = CGRectInset(frame, 10.0, 0.0)
            print(pageImages[page].name!)
            print(pageImages[page].photoName!)
            
            let viewController:SingleChallengeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("singleChallengeController") as! SingleChallengeViewController
            viewController.challengeName = pageImages[page].name!
            viewController.challengeImageName = pageImages[page].photoName!
            
            viewController.view.frame = frame
            scrollView.addSubview(viewController.view)
            pageViews[page] = viewController
        }
    }
    
    func btnOpenAddView(){
        UIView.animateWithDuration(0.1, animations: {
                self.addChallengeButtonImageView!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
            }, completion: {
                completed in
                self.addChallengeButtonImageView!.transform = CGAffineTransformMakeRotation(CGFloat(0))
                if self.addChallengeButtonImageView!.image == UIImage(named: "addpng") {
                    self.addChallengeButtonImageView!.image = UIImage(named: "closepropper")
                    UIView.animateWithDuration(0.1, animations: {
                        self.isAddChallengesOpen = true
                        self.navigationController?.topViewController?.title = "Add yours"
                        self.dimmingView.alpha = 1
                        self.addChallengeView.frame = CGRectMake(0, self.addChallengeView.frame.size.height/2, self.addChallengeView.frame.size.width, self.addChallengeView.frame.size.height)
                    })
                } else {
                    self.addChallengeButtonImageView!.image = UIImage(named: "addpng")
                    UIView.animateWithDuration(0.3, animations: {
                        self.isAddChallengesOpen = false
                        self.navigationController?.topViewController?.title = "Challenges"
                        self.dimmingView.alpha = 0
                        self.addChallengeView.frame = CGRectMake(0, -self.addChallengeView.frame.size.height/2, self.addChallengeView.frame.size.width, self.addChallengeView.frame.size.height)
                    })
                }
        })
    }
    
    func purgePage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.view.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    
    @IBAction func photoButtonClicked(sender: SideMenuButton) {
        if let cameraController = self.cameraController {
            cameraController.prepareToChooseFromLibrary()
        }
    }
    
    @IBAction func videoButtonClicked(sender: SideMenuButton) {
        if let cameraController = self.cameraController {
            cameraController.prepareForCapture()
        }
    }
    
    func dimmingViewTouched(sender:UITapGestureRecognizer){
        btnOpenAddView()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisiblePages()
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if isAddChallengesOpen {
            btnOpenAddView()
        }
        
    }
    
}
