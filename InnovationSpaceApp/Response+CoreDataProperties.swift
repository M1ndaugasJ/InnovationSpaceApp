//
//  Response+CoreDataProperties.swift
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

extension Response {

    @NSManaged var responseVideoFileName: String?
    @NSManaged var responseImageFileName: String?
    @NSManaged var title: String?
    @NSManaged var challenge: Challenge?

}
