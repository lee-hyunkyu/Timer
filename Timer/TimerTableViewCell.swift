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
    weak var timeTracker: NSTimer?
    private var showingTotal = true
    var currentSession: Session?
    
    @IBAction func changeTimerStatus(sender: UIButton) {
        if actionButton.currentTitle == Names.StartTitle {
            actionButton.setTitle(Names.CancelTitle, forState: UIControlState.Normal)
            context?.performBlockAndWait { [unowned self] in
                Session.createSessionToTimer(self.timer, inManagedObjectContext: self.context!)
            }
            do {
                try context?.save()
            } catch {
                print("Context save error, ChangeTimerStatus")
            }
            timeTracker = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(fire(_:)), userInfo: nil, repeats: true)
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
            
            self.timerLabel.text = timer.timerValueAsString()
            timeTracker?.invalidate()
            timeTracker = nil
        }
    }
    
    func fire(timer: NSTimer) {
        if showingTotal {
            self.timerLabel.text = self.timer.timerValueAsString()
        } else {
            self.timerLabel.text = currentSession?.sessionValueAsString() ?? "00:00:00"
        }
    }
    
    @objc
    func showDifferentTimer(gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .Ended:
            showingTotal = !showingTotal
            if showingTotal {
                self.timerLabel.text = self.timer.timerValueAsString()
            } else {
                currentSession = self.timer.currentSession()
                self.timerLabel.text = currentSession?.sessionValueAsString() ?? "00:00:00"
            }
        default: break
        }
    }
    

}
