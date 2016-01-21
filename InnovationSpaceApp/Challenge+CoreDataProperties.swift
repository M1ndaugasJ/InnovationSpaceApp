//
//  Challenge+CoreDataProperties.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/20/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Challenge {

    @NSManaged var challengeTitle: String?
    @NSManaged var imageLocation: String?
    @NSManaged var videoLocation: String?
    @NSManaged var videoChallenge: NSNumber?
    @NSManaged var challengeDescription: String?

}
