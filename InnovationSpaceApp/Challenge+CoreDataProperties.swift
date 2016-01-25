//
//  Challenge+CoreDataProperties.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/24/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Challenge {

    @NSManaged var challengeDescription: String?
    @NSManaged var challengeTitle: String?
    @NSManaged var imageLocation: String?
    @NSManaged var videoChallenge: NSNumber?
    @NSManaged var videoLocation: String?
    @NSManaged var responses: NSSet?

}
