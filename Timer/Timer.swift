//
//  Timer.swift
//  Timer
//
//  Created by Hyunkyu Lee on 7/18/16.
//  Copyright © 2016 Hyunkyu Lee. All rights reserved.
//

import Foundation
import CoreData


class Timer: NSManagedObject {

    // Creates a Timer
    class func createTimerWithInfo(name: String, inProject project: Project?, inManagedObjectContext context: NSManagedObjectContext) -> Timer? {
        if let newTimer = NSEntityDescription.insertNewObjectForEntityForName(Names.Entity, inManagedObjectContext: context) as? Timer {           // TODO: get rid of the string?
            newTimer.name = name
            newTimer.id = NSUUID().UUIDString
            newTimer.isActive = false
            newTimer.sessions = nil
            newTimer.projects = nil
            guard let superProject = project else { return newTimer }           // only continue if there is a project passed in
            let mutableProjectSet = newTimer.mutableSetValueForKey(Names.ProjectSet)   // TODO: get rid of this fucking string
            mutableProjectSet.addObject(superProject)
            superProject.orderOfTimers.append(newTimer.id!)
            
            superProject.saveOrderOfTimers()
            
            return newTimer
        }
        return nil
        
    }
    
    func currentValue() -> (Int, Int, Int) {
        var today: NSDate {
            return NSCalendar.currentCalendar().startOfDayForDate(NSDate())
        }
        var todaySessions: [Session] {
            var sessions = [Session]()
            if let sessionsInTimer = self.sessions {
                for element in sessionsInTimer {
                    if let session = element as? Session, let earlierDate = session.startTime?.earlierDate(today) {
                        if earlierDate.isEqualToDate(today) {
                            sessions.append(session)
                        }
                    }
                }
            }
            return sessions
        }
        var allHours = 0
        var allMinutes = 0
        var allSeconds = 0
        for session in todaySessions {
            let (hourInSession, minuteInSession, secondInSession) = session.convertSessionValue()
            allHours += hourInSession
            allMinutes += minuteInSession
            allSeconds += secondInSession
        }
        
        // in case seconds, minutes overflow
        if allSeconds > Int(Session.SecondsInOneMinute) {
            let overflowMinutes = allSeconds % Int(Session.SecondsInOneMinute)
            allSeconds -= overflowMinutes*Int(Session.SecondsInOneMinute)
            allMinutes += overflowMinutes
        }
        if allMinutes > Int(Session.MinutesInOneHour) {
            let overflowHours = allMinutes % Int(Session.MinutesInOneHour)
            allMinutes -= overflowHours * Int(Session.MinutesInOneHour)
            allHours += overflowHours
        }
        return (allHours, allMinutes, allSeconds)
    }
    
    struct Names {
        static let ProjectSet = "projects"
        static let Entity = "Timer"
        static let ID = "id"
        static let Sessions = "sessions"
    }
}
