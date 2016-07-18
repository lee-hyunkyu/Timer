//
//  Project.swift
//  Timer
//
//  Created by Hyunkyu Lee on 7/18/16.
//  Copyright © 2016 Hyunkyu Lee. All rights reserved.
//

import Foundation
import CoreData


class Project: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    class func createProjectWithName(name: String, inManagedObjectContext context: NSManagedObjectContext) -> Project? {
        if let newProject = NSEntityDescription.insertNewObjectForEntityForName(Names.Entity, inManagedObjectContext: context) as? Project {
            newProject.name = name
            newProject.id = NSUUID().UUIDString
            newProject.subTimers = nil
            return newProject
        }
        
        return nil
    }
    
    struct Names {
        static let Entity = "Project"
    }
    
    

}
