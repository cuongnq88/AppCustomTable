//
//  MainTableViewController.swift
//  AppCustomTable
//
//  Created by nguyen quoc cuong on 12/10/15.
//  skype : cuongnq88
//  mail: cuongnguyenquoc88@gmail.com
//  Copyright Â© 2015 nguyen quoc cuong. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController , PTATableViewCellDelegate {
    
    var objects = ["Swipe Me Left or Right", "Swipe Me Left or Right"]
    
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
        objects += ["Swipe Me Left or Right"]
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
    
    // copy all method tableview to source code of you
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PTATableViewCell
        
        let buttons = ["A","B","C"] // create list name of button
        let colors = [UIColor.greenColor(), UIColor.darkGrayColor(), UIColor.redColor()] // create list color of button
        let actions = ["buttonActionFirst:","buttonActionSecond:","buttonActionThird:"] // create list action of button
        
        let leftButtons = viewWithImage(named: "check")
        //create view container list button
        /*properties changing lines*/
        //lineButton = 0 : hiden lines
        //lineButton = 1 : display lines
        let rightButtons = makeButton(CGSize(width: 50,height: cell.bounds.height),lineButton: 0,buttons: buttons,colors: colors,actions: actions)
        //caculate percentage for rightPercentage
        let rightPercentage = Double(rightButtons.width)/Double(cell.bounds.width)
        
        cell.delegate = self
        cell.textLabel?.text = objects[indexPath.row]
        
        let greenColor = UIColor(red: 85.0/255.0, green: 213.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        
        cell.setPanGesture(.LeftToRight, mode: .Switch, color: greenColor, view: leftButtons.view)
        cell.setPanGesture(.RightToLeft, mode: .Switch, color: UIColor.clearColor(), view: rightButtons.view)
        
        cell.leftToRightAttr.triggerPercentage = 0.2
        cell.leftToRightAttr.rubberbandBounce = true
        cell.leftToRightAttr.viewBehavior = .DragWithPanThenStick
        
        cell.rightToLeftAttr.triggerPercentage = rightPercentage
        cell.rightToLeftAttr.rubberbandBounce = false
        cell.rightToLeftAttr.viewBehavior = .StickThenDragWithPan
        
        return cell
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        print("shouldHighlightRowAtIndexPath")
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PTATableViewCell
        if(cell.isOpenRight) {
            cell.swipeToOriginRight()
            return false;
        }
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Pan Trigger Action (Required)
    
    func tableViewCell(cell: PTATableViewCell, didTriggerState state: PTATableViewItemState, withMode mode: PTATableViewItemMode) {
        // please mark or add the left-right dragging trigger action.
        if(state == .LeftToRight) {
            if let indexPath = tableView.indexPathForCell(cell) {
                //input code when the left-right dragging trigger action.
                print("row \(indexPath.row)'s switch was triggered")
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
    
    // Mark: - Method make button
    
    func makeButton(sizeButton: CGSize,lineButton: Int,buttons:[String], colors:[UIColor], actions:[String]) -> (view:UIView, width:Int) {
        let viewWidth = buttons.count * (Int(sizeButton.width) + lineButton)
        let placeHolder = UIView(frame: CGRect(x:0,y: 0,width: viewWidth,height: Int(sizeButton.height)))
        
        for (i,text) in buttons.enumerate() {
            let button = UIButton(type: .Custom)
            button.setTitle(text, forState: .Normal)
            button.frame = CGRect(x: (Int(sizeButton.width) + lineButton)*i, y: 0, width: Int(sizeButton.width), height: Int(sizeButton.height))
            button.backgroundColor = colors[i]
            let action : Selector = Selector(actions[i])
            button.addTarget(self, action: action, forControlEvents: .TouchUpInside)
            placeHolder.addSubview(button)
        }
        return (view: placeHolder, width: viewWidth)
    }
    
    // Mark: - Method make button action
    
    // action of button name A
    func buttonActionFirst(sender:UIButton) {
        //your input code
        let alert = UIAlertView()
        alert.title = "Alert"
        alert.message = "Here's a message button action " + sender.currentTitle!
        alert.addButtonWithTitle("Understod")
        alert.show()
    }
    
    // action of button name B
    func buttonActionSecond(sender:UIButton) {
        //your input code
        let alert = UIAlertView()
        alert.title = "Alert"
        alert.message = "Here's a message button action " + sender.currentTitle!
        alert.addButtonWithTitle("Understod")
        alert.show()
    }
    
    // action of button name C
    func buttonActionThird(sender:UIButton) {
        //your input code
        let alert = UIAlertView()
        alert.title = "Alert"
        alert.message = "Here's a message button action " + sender.currentTitle!
        alert.addButtonWithTitle("Understod")
        alert.show()
    }
    
}