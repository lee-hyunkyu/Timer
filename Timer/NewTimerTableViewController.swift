//
//  NewTimerTableViewController.swift
//  Timer
//
//  Created by Hyunkyu Lee on 7/18/16.
//  Copyright © 2016 Hyunkyu Lee. All rights reserved.
//

import UIKit
import CoreData
class NewTimerTableViewController: UITableViewController, UITextFieldDelegate {
    
    var context: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    var projects: [Project]! {
        didSet {
            tableView.reloadData()
        }
    }
    var selectedProject: Project?
    var timerName: String?
    var addNewProjectCell: AddNewProjectTableViewCell?
    var newProjectName: String?
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    struct Cells {
        static let Timer = "Timer"
        static let Project = "Project"
        static let NewProject = "AddNewProject"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.enabled = false
        doneButton.tintColor = UIColor.grayColor().colorWithAlphaComponent(0.4)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }else {
            return projects.count + 1
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier(Cells.Timer, forIndexPath: indexPath)
            if let newTimerCell = cell as? NewTimerTableViewCell {
                newTimerCell.textField.delegate = self
            }
        } else {
            if indexPath.row == (tableView.numberOfRowsInSection(indexPath.section) - 1) {
                // This is the last row so this is were you add a new project
                cell = tableView.dequeueReusableCellWithIdentifier(Cells.NewProject, forIndexPath: indexPath)
                if let newProjectCell = cell as? AddNewProjectTableViewCell {
                    newProjectCell.AddProjectButton.enabled = false
                    newProjectCell.textField.delegate = self
                    addNewProjectCell = newProjectCell
                }
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier(Cells.Project, forIndexPath: indexPath)
                cell.textLabel?.text = projects[indexPath.row].name
            }
            
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if let _ = cell as? NewTimerTableViewCell {
            // do nothing
        } else {
            // if it is a project
            let backgroundView = UIView(frame: (cell?.frame)!)
            backgroundView.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.1)
            cell?.selectedBackgroundView = backgroundView
            selectedProject = projects[indexPath.row]
        }
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
    
    // MARK: Storyboard 
    
    @IBAction func addProject(sender: UIButton) {
        context?.performBlockAndWait { [unowned self] in
            if let projectName = self.newProjectName, let project = Project.createProjectWithName(projectName, inManagedObjectContext: self.context!) {
                self.projects.append(project)
            }
        }
        do {
            try context?.save()
        } catch let error {
            print("Add Project Error")
        }
        
        /*
        context?.performBlockAndWait { [unowned self] in
            if let project = Project.createProjectWithName(self.textField.text!, inManagedObjectContext: self.context!) {
                self.tableViewController!.projects.append(project)
                print("Success")
            }
        }
        do {
            try context?.save()
        } catch let error {
            print("Error")
            print("Add Project")
        }
 */
    }
    
    
    // MARK: - Text Field Delegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        //textField.becomeFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.placeholder != nil { // the text field is for add new project
            addNewProjectCell?.AddProjectButton.enabled = true
            addNewProjectCell?.AddProjectButton.tintColor = nil
            newProjectName = textField.text
        } else { // the text field is for the task name
            timerName = textField.text
            doneButton.enabled = true
            doneButton.tintColor = nil
        }
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
