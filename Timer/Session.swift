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
        if !(timer.isActive as! Bool) {
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
    
    func endSession() -> Bool {
        if self.endTime != nil {
            return false
        } else {
            self.endTime = NSDate()
            return true
        }
    }
    
    func convertSessionValue() -> (Int, Int, Int) {                             //Hour, Minute, Seconds
        var endTime: NSDate                                                     //Value to compare to
        if self.endTime != nil {
            endTime = self.endTime!
        } else {
            endTime = NSDate()
        }
        
        var remainingDifferenceInSeconds = endTime.timeIntervalSinceDate(self.startTime!) as Double
        
        // Find difference in Hours
        
        let hours = Int(remainingDifferenceInSeconds/Session.SecondsInOneHour)
        remainingDifferenceInSeconds -= hours*Session.SecondsInOneHour
        
        // Find difference in Minutes
        
        let minutes = Int(remainingDifferenceInSeconds/Session.SecondsInOneMinute)
        remainingDifferenceInSeconds -= minutes*Session.SecondsInOneMinute
        
        // Find difference in Seconds
        
        let seconds = remainingDifferenceInSeconds
        
        return (Int(hours), Int(minutes), Int(seconds))
        
    }
    
    struct Names {
        static let Entity = "Session"
    }
    static let SecondsInOneHour = 3600.0
    static let SecondsInOneMinute = 60.0
    static let MinutesInOneHour = 60.0
    
}
