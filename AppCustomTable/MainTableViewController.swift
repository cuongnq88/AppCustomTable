//
//  MainTableViewController.swift
//  AppCustomTable
//
//  Created by nguyen quoc cuong on 12/10/15.
//  Copyright © 2015 nguyen quoc cuong. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController , PTATableViewCellDelegate {

    var objects = ["Swipe Me Left or Right", "Swipe Me Left to Delete"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.registerClass(PTATableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        objects += ["Swipe Me Left to Delete"]
        let indexPath = NSIndexPath(forRow: (objects.count - 1), inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func viewWithImage(named named: String) -> UIView {
        let imageView = UIImageView(image: UIImage(named: named))
        imageView.contentMode = .Center
        return imageView
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PTATableViewCell
        
        cell.delegate = self
        cell.textLabel?.text = objects[indexPath.row]
        
        let redColor = UIColor(red: 232.0/255.0, green: 61.0/255.0, blue: 14.0/255.0, alpha: 1.0)
        
        cell.setPanGesture(.LeftToRight, mode: .Switch, color: view.tintColor, view: viewWithImage(named: "check"))
        cell.setPanGesture(.RightToLeft, mode: .Exit, color: redColor, view: viewWithImage(named: "cross"))
        
        cell.rightToLeftAttr.triggerPercentage = 0.1
        cell.rightToLeftAttr.rubberbandBounce = true
//        cell.rightToLeftAttr.viewBehavior = .DragWithPanThenStick
        cell.rightToLeftAttr.viewBehavior = .StickThenDragWithPan
//        cell.rightToLeftAttr.viewBehavior = .DragWithPan
        
        cell.leftToRightAttr.triggerPercentage = 0.1
        cell.leftToRightAttr.rubberbandBounce = true
//        cell.leftToRightAttr.viewBehavior = .DragWithPanThenStick
        cell.leftToRightAttr.viewBehavior = .StickThenDragWithPan
//        cell.leftToRightAttr.viewBehavior = .DragWithPan
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // Implement your own `tableView:didSelectRowAtIndexPath:` here.
    }
    
    // MARK: - Pan Trigger Action (Required)
    
    func tableViewCell(cell: PTATableViewCell, didTriggerState state: PTATableViewItemState, withMode mode: PTATableViewItemMode) {
        if let indexPath = tableView.indexPathForCell(cell) {
            switch mode {
            case .Switch:
                print("row \(indexPath.row)'s switch was triggered")
            case .Exit:
                print("row \(indexPath.row)'s exit was triggered")
                objects.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            default:
                break
            }
        }
    }
    
    // MARK: - Pan Trigger Action (Optional)
    
    func tableViewCellDidStartSwiping(cell: PTATableViewCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            print("row \(indexPath.row) started swiping")
        }
    }
    
    func tableViewCellIsSwiping(cell: PTATableViewCell, withPercentage percentage: Double) {
        if let indexPath = tableView.indexPathForCell(cell) {
            print("row \(indexPath.row) is being swiped with percentage: \(percentage * 100.0)")
        }
    }
    
    func tableViewCellDidEndSwiping(cell: PTATableViewCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            print("row \(indexPath.row) ended swiping")
        }
    }

}
















