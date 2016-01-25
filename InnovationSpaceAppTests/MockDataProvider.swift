//
//  MockDataProvider.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/25/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//

import UIKit
import CoreData

@testable import InnovationSpaceApp
class MockDataProvider: NSObject {
    
    var addChallengeGotCalled = false
    
    var managedObjectContext: NSManagedObjectContext?
    weak var tableView: UITableView!
    func addChallenge(challenge: Challenge) { addChallengeGotCalled = true }
    func fetch() { }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
