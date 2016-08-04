//
//  BatchSelectionTableViewCell.swift
//  BatchEditing
//
//  Created by Hyunkyu Lee on 7/23/16.
//  Copyright © 2016 Hyunkyu Lee. All rights reserved.
//

import UIKit

class BatchSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    private var editingLeftView: UIView?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func addSelectionCircle(differenceBetween: Double) {
        let origin = CGPoint(x: 0, y: 0)
        let view = UIView(frame: CGRect(origin: origin, size: CGSize(width: differenceBetween, height: Double(self.bounds.height))))
        editingLeftView = view
        self.addSubview(editingLeftView!)
        addCircleToView(editingLeftView!)
    }
    
    private func addCircleToView(view: UIView) {
        let width = view.bounds.width
        let height = view.bounds.width
        
        var radius: CGFloat?
        if width > height {
            radius = height * 0.3
        } else {
            radius = width * 0.3
        }
        
        let center = CGPoint(x: width/2, y: height/2)
        let origin = CGPoint(x: center.x - radius!, y: center.y - radius!)
        
        let frame = CGRect(origin: origin, size: CGSize(width: radius! * 2, height: radius! * 2))
        let circleView = UIView(frame: frame)
        circleView.layer.cornerRadius = radius!
        circleView.layer.borderColor = UIColor.redColor().CGColor
        circleView.layer.borderWidth = 3.0
        view.addSubview(circleView)
    }
    
    func putInEditingMode(target: UITableViewController, withAction action: Selector, withEditingDifference differenceBetween: Double) {
        addSelectionCircle(differenceBetween)
        addCircleToView(editingLeftView!)
        editingLeftView?.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
    
    func putOutEditingMode() {
        editingLeftView = nil
    }

}
