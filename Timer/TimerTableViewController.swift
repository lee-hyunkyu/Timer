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
    
    // MARK: Storyboard
    
    @IBAction func createNewTimer(sender: UIBarButtonItem) {
        
                
    }
    // MARK: View

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        // Number of Projects
        let request = NSFetchRequest(entityName: Project.Names.Entity)
        return context?.countForFetchRequest(request, error: nil) ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if projects.isEmpty {
            let request = NSFetchRequest(entityName: Project.Names.Entity)
            if let projectResults = (try? context?.executeFetchRequest(request)) as? [Project] {
                projects = projectResults
            }
        }
        return projects[section].subTimers?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Cells.TimerCell, forIndexPath: indexPath)

        if let timerCell = cell as? TimerTableViewCell {
            let projectData = projects[indexPath.section]
            let timerSet = projectData.subTimers?.allObjects as! [Timer]
            let timerID = projectData.orderOfTimers[indexPath.row]
            var timer: Timer?
            for possibleTimer in timerSet {
                if possibleTimer.id == timerID {
                    timer = possibleTimer
                }
            }
            timerCell.nameOfTimerLabel?.text = timer?.name
            timerCell.timerLabel?.text = timer?.id?.substringToIndex((timer?.id?.startIndex.advancedBy(4))!)
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
