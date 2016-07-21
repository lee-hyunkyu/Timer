//
//  TimerTableViewCell.swift
//  Timer
//
//  Created by Hyunkyu Lee on 7/18/16.
//  Copyright © 2016 Hyunkyu Lee. All rights reserved.
//

import UIKit

class TimerTableViewCell: UITableViewCell {

    @IBOutlet weak var actionButton: UIButton!                                  // will be used to either start or stop the timer
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var nameOfTimerLabel: UILabel!
    var timer: Timer!
    
    @IBAction func changeTimerStatus(sender: UIButton) {
    }
    

}
