//
//  AddNewProjectTableViewCell.swift
//  Timer
//
//  Created by Hyunkyu Lee on 7/19/16.
//  Copyright © 2016 Hyunkyu Lee. All rights reserved.
//

import UIKit
import CoreData

class AddNewProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var AddProjectButton: UIButton!
    var context: NSManagedObjectContext?
    
    @IBAction func addProject() {
        context?.performBlockAndWait { [unowned self] in
            Project.createProjectWithName(self.textField.text!, inManagedObjectContext: self.context!)
        }
    }
    
}
