//
//  TimerTableViewCell.swift
//  Timer
//
//  Created by Hyunkyu Lee on 7/18/16.
//  Copyright © 2016 Hyunkyu Lee. All rights reserved.
//

import UIKit
import CoreData

class TimerTableViewCell: UITableViewCell {
    
    struct Names {
        static let StartTitle = "Start"
        static let CancelTitle = "Cancel"
    }

    @IBOutlet weak var actionButton: UIButton!                                  // will be used to either start or stop the timer
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var nameOfTimerLabel: UILabel!
    var timer: Timer!
    var context: NSManagedObjectContext?
    
    @IBAction func changeTimerStatus(sender: UIButton) {
        if actionButton.currentTitle == Names.StartTitle {
            actionButton.setTitle(Names.CancelTitle, forState: UIControlState.Normal)
            context?.performBlockAndWait { [unowned self] in
                Session.createSessionToTimer(self.timer, inManagedObjectContext: self.context!)
                self.timer.isActive = true
            }
            do {
                try context?.save()
            } catch {
                print("Context save error, ChangeTimerStatus")
            }
        } else {
            actionButton.setTitle(Names.StartTitle, forState: .Normal)
            context?.performBlockAndWait { [unowned self] in
                self.timer.endSession()
            }
            do {
                try context?.save()
            } catch {
                print("Context save error, Change Timer Status else")
            }
            
            if let (_, minutes, seconds) = timer?.currentValue() {
                let minuteTime = "\(minutes)".asTimeValue()
                let secondTime = "\(seconds)".asTimeValue()
                self.timerLabel.text = minuteTime + ":" + secondTime             // ignore hours for now, will add later
                print(minuteTime + ":" + secondTime)
            } else {
                
            }
        }
    }
    

}
