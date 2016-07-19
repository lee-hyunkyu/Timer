//
//  AddNewProjectTableViewCell.swift
//  Timer
//
//  Created by Hyunkyu Lee on 7/19/16.
//  Copyright © 2016 Hyunkyu Lee. All rights reserved.
//

import UIKit
import CoreData

class AddNewProjectTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    @IBOutlet weak var AddProjectButton: UIButton! {
        didSet {
            AddProjectButton.tintColor = UIColor.grayColor().colorWithAlphaComponent(0.4)
        }
    }
    var context: NSManagedObjectContext?
    
    @IBAction func addProject() {
        context?.performBlockAndWait { [unowned self] in
            Project.createProjectWithName(self.textField.text!, inManagedObjectContext: self.context!)
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        //textField.becomeFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text != nil && textField.text != "" {
            AddProjectButton.tintColor = nil
            AddProjectButton.enabled = true
        }
        return true
    }
    
}
