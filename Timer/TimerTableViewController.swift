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
    var timers = [Timer]()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var timerOrder = [String]() {
        didSet {
            defaults.setObject(timerOrder, forKey: Cells.Order)
        }
    }
    
    // MARK: Constants
    
    private struct Cells {
        static let TimerCell = "Timer"                                          // Timer Cell Reuse Identifier
        static let Order = "Timer Order"
    }
    
    private struct Segues {
        static let NewTimer = "NewTimer"
    }
    
    // MARK: Storyboard
    
    @IBAction func createNewTimer(sender: UIBarButtonItem) {
                
    }
    // MARK: View

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateProjects()
        updateTimers()
        updateOrder()        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        // Just 1
        
        /* // Number of Projects
        let request = NSFetchRequest(entityName: Project.Names.Entity)
        var count = 0
        context?.performBlockAndWait { [unowned self] in
            count = self.context?.countForFetchRequest(request, error: nil) ?? 0
        }
         */
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var total = 0
        for project in projects {
            total = total + (project.subTimers?.count ?? 0)
        }
        return total
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Cells.TimerCell, forIndexPath: indexPath)

        if let timerCell = cell as? TimerTableViewCell {
            let timerID = timerOrder[indexPath.row]
            var timer: Timer?
            for timerData in timers {
                if timerData.id == timerID {
                    timer = timerData
                }
            }
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

    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let movingTimerID = timerOrder[fromIndexPath.row]
        if toIndexPath.row > fromIndexPath.row {
            timerOrder.insert(movingTimerID, atIndex: toIndexPath.row + 1)
        } else {
            timerOrder.insert(movingTimerID, atIndex: toIndexPath.row)
        }
        if toIndexPath.row > fromIndexPath.row {
            timerOrder.removeAtIndex(fromIndexPath.row)
        } else {
            timerOrder.removeAtIndex(fromIndexPath.row + 1)
        }
        updateOrder()
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    

    
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
        var newTimer: Timer?
        if let newTimerVC = segue.sourceViewController as? NewTimerTableViewController {
            let timerName = newTimerVC.timerName
            if let project = newTimerVC.selectedProject {
                context?.performBlockAndWait { [unowned self] in
                    newTimer = Timer.createTimerWithInfo(timerName!, inProject: project, inManagedObjectContext: self.context!)
                }
            }else {
                let request = NSFetchRequest(entityName: Project.Names.Entity)
                request.predicate = NSPredicate(format: "\(Project.Names.ID) = %@", Project.defaultID!)
                context?.performBlockAndWait { [unowned self] in
                    if let defaultProject = (try? self.context!.executeFetchRequest(request))?.first as? Project {
                        newTimer = Timer.createTimerWithInfo(timerName!, inProject: defaultProject, inManagedObjectContext: self.context!)
                    }
                }
            }
        }
        do {
            try context?.save()
        } catch let error {
            print("Outside \(error)")
        }
        if let timer = newTimer {
            timerOrder.append(timer.id!)
            print("Timer Created")
        }
        updateProjects()
        updateTimers()
        updateOrder()
        tableView.reloadData()
        
    }
    
    private func updateProjects() {
        context?.performBlockAndWait { [unowned self] in
            let request = NSFetchRequest(entityName: Project.Names.Entity)
            if let projectResults = (try? self.context!.executeFetchRequest(request)) as? [Project] {
                self.projects = projectResults
            }
        }
    }
    
    private func updateTimers() {
        context?.performBlockAndWait { [unowned self] in
            let request = NSFetchRequest(entityName: Timer.Names.Entity)
            if let timerRequest = (try? self.context!.executeFetchRequest(request)) as? [Timer] {
                self.timers = timerRequest
            }
        }
    }
    
    // must come after updateTimers()
    private func updateOrder() {
        if let order = defaults.objectForKey(Cells.Order) as? [String] {
            if !order.elementsEqual(timerOrder) {                               // timer order has changed
                defaults.setObject(timerOrder, forKey: Cells.Order)
            }
            timerOrder = order
        } else {
            for timer in timers {
                timerOrder.append(timer.id!)
            }
            defaults.setObject(timerOrder, forKey: Cells.Order)
        }
    }
}

extension String {
    func asTimeValue() -> String {
        if (self as NSString).intValue < 10 {
            return "0".stringByAppendingString(self)
        } else {
            return self
        }
    }
}


















