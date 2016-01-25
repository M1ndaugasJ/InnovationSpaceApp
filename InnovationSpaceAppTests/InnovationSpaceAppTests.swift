//
//  InnovationSpaceAppTests.swift
//  InnovationSpaceAppTests
//
//  Created by Mindaugas on 11/23/15.
//  Copyright © 2015 Mindaugas. All rights reserved.
//

import XCTest
@testable import InnovationSpaceApp

class InnovationSpaceAppTests: XCTestCase {
    
    var viewController: ChallengesTableViewController!
    
    override func setUp() {
        super.setUp()
         viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("challengesTableViewController") as! ChallengesTableViewController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testFileNameCreation(){
        let saveHelper = DataSaveHelper(moc: DataController().managedObjectContext)
        let fileName = saveHelper.fileName(".png", stringToAppend: nil)
        XCTAssertEqual(fileName, "data")
    }
    
    func testFileSaved(){
        let saveHelper = DataSaveHelper(moc: DataController().managedObjectContext)
        saveHelper.saveVideo(NSURL(fileURLWithPath: "url"))
        XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath("url"))
    }
    
    func testDataProviderHasTableViewPropertySetAfterLoading() {

        let mockDataProvider = MockDataProvider()
        
        viewController.dataController.managedObjectContext = mockDataProvider.managedObjectContext!
        
        XCTAssertNil(mockDataProvider.tableView, "Before loading the table view should be nil")
        
        let _ = viewController.view
        
        XCTAssertTrue(mockDataProvider.tableView != nil, "The table view should be set")
        XCTAssert(mockDataProvider.tableView === viewController.tableView,
            "The table view should be set to the table view of the data source")
    }
    
    func testChallengeAdditionHasBeenCalled(){
        let mockDataSource = MockDataProvider()
        
        viewController.dataController.managedObjectContext = mockDataSource.managedObjectContext!
        
        XCTAssert(mockDataSource.addChallengeGotCalled, "addChallenge should have been called")
    }
    
//    func testChallengeAddition(){
//        var challenge = Challenge(entity: 
//    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            
        }
    }
    
}
