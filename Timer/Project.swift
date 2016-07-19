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
    
    // class func 
    // For every project, retrieve the order of timers
    // For every project, save the order of timer
    
    struct Names {
        static let Entity = "Project"
        static let DefaultProject = "Inbox"
        static let ID = "id"
        static let defaultFile = "/DefaultID.txt"
    }
    
    // Saved in the Documents Directory
    // ~/Documents/DefaultID.txt
    static var defaultID: String?
    
    func saveOrderOfTimers() {
        
    }
    
    
    

}
