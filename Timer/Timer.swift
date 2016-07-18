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
            return newTimer
        }
        return nil
        
    }
    
    private struct Names {
        static let ProjectSet = "projects"
        static let Entity = "Timer"
    }
}
