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
    @IBOutlet weak var AddProjectButton: UIButton! {
        didSet {
            AddProjectButton.tintColor = UIColor.grayColor().colorWithAlphaComponent(0.4)
        }
    }
    
}
