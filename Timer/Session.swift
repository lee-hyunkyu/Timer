//
//  Session.swift
//  Timer
//
//  Created by Hyunkyu Lee on 7/18/16.
//  Copyright © 2016 Hyunkyu Lee. All rights reserved.
//

import Foundation
import CoreData


class Session: NSManagedObject {
    
    class func createSessionToTimer(timer: Timer, inManagedObjectContext context: NSManagedObjectContext) -> Session? {
        // Only create a new session if the timer isn't active.
        if timer.isActive as! Bool {
            if let newSession = NSEntityDescription.insertNewObjectForEntityForName(Names.Entity, inManagedObjectContext: context) as? Session {
                newSession.id = NSUUID().UUIDString
                newSession.startTime = NSDate()
                newSession.endTime = nil
                let timerSessions = timer.mutableSetValueForKey(Timer.Names.Sessions)
                timerSessions.addObject(newSession)
                return newSession
            }
        }
        return nil
        
    }
    
    struct Names {
        static let Entity = "Session"
        
    }
    
}
