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
    
    class func setOrderOfTimers(withFileManager fileManager: NSFileManager, inDirectoryPath directory: String, inManagedObjectContext context: NSManagedObjectContext) -> Bool {
        let request = NSFetchRequest(entityName: Project.Names.Entity)
        if let projects = (try? context.executeFetchRequest(request)) as? [Project] {
            for project in projects {
                do {
                    if let projectFilePath = project.orderOfTimerFilePath() {
                        let timerOrder = try NSString(contentsOfFile: directory + projectFilePath, encoding: NSUTF8StringEncoding) as String
                        timerOrder.enumerateLines{ (line, stop) in
                            print(line, terminator: " Done \n")
                            project.orderOfTimers.append(line)
                        }
                    }
                } catch {
                    print("Set order of timers: ", terminator: " File Not Read for \(project.id)")
                }
            }
        }
        
        return false
    }
    
    
    
    struct Names {
        static let Entity = "Project"
        static let DefaultProject = "Inbox"
        static let ID = "id"
        static let defaultFile = "/DefaultID.txt"
    }
    
    // Saved in the Documents Directory
    // ~/Documents/DefaultID.txt
    static var defaultID: String?
    // ~/Documents/\(ProjectID).txt
    var orderOfTimers = [String]() {
        didSet {
            var timerOrder: String = ""
            for timerID in orderOfTimers {
                timerOrder.appendContentsOf(timerID + "\n")
            }
            let fileManager = NSFileManager()
            if let documentsDirectoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first, let documentPath = documentsDirectoryURL.path {
                let data = timerOrder.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                do {
                    if let projectFilePath = self.orderOfTimerFilePath() {
                        try data?.writeToFile(documentPath + projectFilePath, options: NSDataWritingOptions.AtomicWrite)
                    }
                } catch {
                    print("Create timer with info", terminator: " Failed to write to file")
                }
            }
        }
    }
    
    func orderOfTimerFilePath() -> String? {
        if let projectID = self.id {
            return "/" + projectID + ".txt"
        }
        
        return nil
    }
    
}
