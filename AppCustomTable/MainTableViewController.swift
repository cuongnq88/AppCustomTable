//
//  MainTableViewController.swift
//  AppCustomTable
//
//  Created by nguyen quoc cuong on 12/10/15.
//  skype : cuongnq88
//  mail: cuongnguyenquoc88@gmail.com
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
    
    func viewWithImage(named named: String) -> (view:UIView, width:Int) {
        let imageView = UIImageView(image: UIImage(named: named))
        imageView.contentMode = .Center
        return (view: imageView, width: Int(imageView.bounds.width))
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

        let leftButtons = viewWithImage(named: "check")
        let rightButtons = makeButton(["A","B","C"])
        let rightPercentage = Double(rightButtons.width)/Double(cell.bounds.width)
        
        cell.delegate = self
        cell.textLabel?.text = objects[indexPath.row]
        
        let greenColor = UIColor(red: 85.0/255.0, green: 213.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        let redColor = UIColor(red: 232.0/255.0, green: 61.0/255.0, blue: 14.0/255.0, alpha: 1.0)
        
        cell.setPanGesture(.LeftToRight, mode: .Switch, color: greenColor, view: leftButtons.view)
        cell.setPanGesture(.RightToLeft, mode: .Switch, color: redColor, view: rightButtons.view)
        
        cell.leftToRightAttr.triggerPercentage = 0.2
        cell.leftToRightAttr.rubberbandBounce = true
        cell.leftToRightAttr.viewBehavior = .DragWithPanThenStick
     
        cell.rightToLeftAttr.triggerPercentage = rightPercentage
        cell.rightToLeftAttr.rubberbandBounce = false
        cell.rightToLeftAttr.viewBehavior = .StickThenDragWithPan
        
        return cell
    }
    
//    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
//        print("click willDeselectRowAtIndexPath")
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PTATableViewCell
//        cell.swipeToTageWith(percentage: 0)
//        return indexPath
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        print("click cell")
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

    // Mark: - Method
    
    func makeButton(buttons:[String]) -> (view:UIView, width:Int) {
        let viewWidth = buttons.count * 51
        let listColor = [UIColor.greenColor(), UIColor.darkGrayColor(), UIColor.redColor()]
        let placeHolder = UIView(frame: CGRect(x:0,y: 0,width: viewWidth,height: 40))
        
        for (i,text) in buttons.enumerate() {
            let button = UIButton(type: .Custom)
            button.setTitle(text, forState: .Normal)
            button.frame = CGRect(x: 51*i, y: 0, width: 50, height: 40)
            button.backgroundColor = listColor[i % listColor.count]
            button.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
            placeHolder.addSubview(button)
        }
        return (view: placeHolder, width: viewWidth)
    }
    
    func buttonAction(sender:UIButton) {
        let alert = UIAlertView()
        alert.title = "Alert"
        alert.message = "Here's a message button action " + sender.currentTitle!
        alert.addButtonWithTitle("Understod")
        alert.show()
    }
    
}
















