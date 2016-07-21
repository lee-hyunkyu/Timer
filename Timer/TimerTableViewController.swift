//
//  TimerTableViewController.swift
//  Timer
//
//  Created by Hyunkyu Lee on 7/18/16.
//  Copyright © 2016 Hyunkyu Lee. All rights reserved.
//

import UIKit
import CoreData

class TimerTableViewController: UITableViewController {
    
    // MARK: Model
    
    var context: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    var projects = [Project]()
    
    // MARK: Constants
    
    private struct Cells {
        static let TimerCell = "Timer"                                          // Timer Cell Reuse Identifier
    }
    
    private struct Segues {
        static let NewTimer = "NewTimer"
    }
    
    // MARK: Storyboard
    
    @IBAction func createNewTimer(sender: UIBarButtonItem) {
                
    }
    // MARK: View

    override func viewDidLoad() {
        super.viewDidLoad()
        updateProjects()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        // Number of Projects
        let request = NSFetchRequest(entityName: Project.Names.Entity)
        var count = 0
        context?.performBlockAndWait { [unowned self] in
            count = self.context?.countForFetchRequest(request, error: nil) ?? 0
        }
        return count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return projects[section].subTimers?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Cells.TimerCell, forIndexPath: indexPath)

        if let timerCell = cell as? TimerTableViewCell {
            
            let project = projects[indexPath.section]
            let timerID = project.orderOfTimers[indexPath.row]
            let timer = project.timerWithID(timerID)
            timerCell.timer = timer
            timerCell.nameOfTimerLabel?.text = timer?.name ?? "No Name"
            timerCell.timerLabel.text = timerCell.timer?.timerValueAsString() ?? "00:00:00"
            timerCell.context = self.context
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController!
        }
        switch segue.identifier! {
        case Segues.NewTimer:
            if let newTimerVC = destination as? NewTimerTableViewController {
                newTimerVC.context = context
                newTimerVC.projects = projects
            }
            
        default: break
        }
    }
    
    @IBAction func cancelNewTimer(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func addNewTimer(segue: UIStoryboardSegue) {
        if let newTimerVC = segue.sourceViewController as? NewTimerTableViewController {
            let timerName = newTimerVC.timerName
            print(timerName)
            if let project = newTimerVC.selectedProject {
                context?.performBlockAndWait { [unowned self] in
                    Timer.createTimerWithInfo(timerName!, inProject: project, inManagedObjectContext: self.context!)
                }
            }else {
                let request = NSFetchRequest(entityName: Project.Names.Entity)
                request.predicate = NSPredicate(format: "\(Project.Names.ID) = %@", Project.defaultID!)
                context?.performBlockAndWait { [unowned self] in
                    if let defaultProject = (try? self.context!.executeFetchRequest(request))?.first as? Project {
                        Timer.createTimerWithInfo(timerName!, inProject: defaultProject, inManagedObjectContext: self.context!)
                    }
                }
            }
        }
        do {
            try context?.save()
        } catch let error {
            print("Outside \(error)")
        }
        updateProjects()
        tableView.reloadData()
        
    }
    
    func updateProjects() {
        context?.performBlockAndWait { [unowned self] in
            let request = NSFetchRequest(entityName: Project.Names.Entity)
            if let projectResults = (try? self.context!.executeFetchRequest(request)) as? [Project] {
                self.projects = projectResults
            }
        }
    }

}

extension String {
    func asTimeValue() -> String {
        if (self as NSString).intValue < 9 {
            return "0".stringByAppendingString(self)
        } else {
            return self
        }
    }
}


















