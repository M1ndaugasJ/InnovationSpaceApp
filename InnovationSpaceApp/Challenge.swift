//
//  Challenge.swift
//  InnovationSpaceApp
//
//  Created by Mindaugas on 1/20/16.
//  Copyright © 2016 Mindaugas. All rights reserved.
//

import Foundation
import CoreData


class Challenge: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func addChallengeResponse(value: Response) {
        self.mutableSetValueForKey("responses").addObject(value)
    }
    
    func getChallengeResponses() -> [Response] {
        var cards: [Response]
        cards = self.responses!.allObjects as! [Response]
        return cards
    }

}
