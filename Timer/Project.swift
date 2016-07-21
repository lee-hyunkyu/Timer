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
    
    var orderOfTimers = [String]()
    
    class func createProjectWithName(name: String, inManagedObjectContext context: NSManagedObjectContext) -> Project? {
        if let newProject = NSEntityDescription.insertNewObjectForEntityForName(Names.Entity, inManagedObjectContext: context) as? Project {
            newProject.name = name
            newProject.id = NSUUID().UUIDString
            newProject.subTimers = nil
            newProject.saveOrderOfTimers()
            return newProject
        }
        
        return nil
    }
    
    class func saveDefaultIDIntoFileSystem(fileManager: NSFileManager) {
        if let projectID = Project.defaultID {
            let fileManager = NSFileManager()
            if let documentsDirectory = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first {
                if !fileManager.fileExistsAtPath(documentsDirectory.absoluteString + Project.Names.defaultFile) {
                    let defaultIDData = projectID.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                    fileManager.createFileAtPath(documentsDirectory.path! + Project.Names.defaultFile, contents: defaultIDData, attributes: nil)
                }
            }
        }
    }
    
    class func setDefaultIDFromFileSystem(fileManager: NSFileManager) {
        if let documentsDirectory = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first {
            do {
                try Project.defaultID = NSString(contentsOfFile: documentsDirectory.path! + Project.Names.defaultFile, encoding: NSUTF8StringEncoding) as String
            } catch {
                print("File not read")
            }
        }
    }
    
    // For every project, retrieve the order of timers
    class func setOrderOfTimers(context: NSManagedObjectContext) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let request = NSFetchRequest(entityName: Names.Entity)
        if let projects = (try? context.executeFetchRequest(request)) as? [Project] {
            for project in projects {
                project.orderOfTimers = defaults.objectForKey(Names.orderOfTimers + project.id!) as! [String]
            }
        }
    }
    // For every project, save the order of timer
    class func saveOrderOfTimers(context: NSManagedObjectContext) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let request = NSFetchRequest(entityName: Names.Entity)
        if let projects = (try? context.executeFetchRequest(request)) as? [Project] {
            for project in projects {
                defaults.setObject(project.orderOfTimers, forKey: Names.orderOfTimers + project.id!)
            }
        }
    }
    
    func timerWithID(id: String) -> Timer? {
        let timers = self.subTimers?.allObjects as! [Timer]
        for timer in timers {
            if timer.id == id {
                return timer
            }
        }
        return nil
    }
    
    struct Names {
        static let Entity = "Project"
        static let DefaultProject = "Inbox"
        static let ID = "id"
        static let defaultFile = "/DefaultID.txt"
        static let orderOfTimers = "Order of Timers" // Add the id of the project after
    }
    
    // Saved in the Documents Directory
    // ~/Documents/DefaultID.txt
    static var defaultID: String?
    
    func saveOrderOfTimers() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(orderOfTimers, forKey: Names.orderOfTimers + self.id!)
    }
    
    
    

}
