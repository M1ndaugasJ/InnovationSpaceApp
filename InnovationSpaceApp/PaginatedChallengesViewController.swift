//
//  PaginatedChallengesViewController.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 12/28/15.
//  Copyright © 2015 Mindaugas. All rights reserved.
//

import UIKit

class PaginatedChallengesViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet var scrollView: UIScrollView!
    var pageImages: [Challenge] = []
    var pageViews: [SingleChallengeViewController?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;
        self.scrollView.contentInset = UIEdgeInsetsMake(0,0,0,0);
        self.navigationController?.topViewController?.title = "Challenges"
        let barButtonItem : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("btnOpenAddView"))
        self.navigationController?.topViewController!.navigationItem.rightBarButtonItem = barButtonItem
        barButtonItem.tintColor = UIColor.blackColor()
        
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
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("addChallengeViewController") as! AddChallengeViewController
        self.presentViewController(vc, animated: true, completion: nil)
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
    
}
