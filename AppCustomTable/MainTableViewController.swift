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
        
//        cell.delegate = self
//        cell.textLabel?.text = objects[indexPath.row]
//        
//        let leftButtons = makeButton(["1","2"])
//        let rightButtons = makeButton(["A","B","C"])
//        
//        cell.setPanGesture(.LeftToRight, mode: .Switch, color: nil, view: leftButtons.view)
//        cell.setPanGesture(.RightToLeft, mode: .Switch, color: nil, view: rightButtons.view)
//        
//        cell.rightToLeftAttr.triggerPercentage = 0
//        cell.rightToLeftAttr.rubberbandBounce = false
//        cell.rightToLeftAttr.viewBehavior = .StickThenDragWithPan
//        
//        cell.leftToRightAttr.triggerPercentage = 0
//        cell.leftToRightAttr.rubberbandBounce = false
//        cell.leftToRightAttr.viewBehavior = .StickThenDragWithPan
        
        cell.delegate = self
        cell.textLabel?.text = objects[indexPath.row]
        
        if indexPath.row == 0 {
            let greenColor = UIColor(red: 85.0/255.0, green: 213.0/255.0, blue: 80.0/255.0, alpha: 1.0)
            
            cell.setPanGesture([.LeftToRight, .RightToLeft], mode: .Switch, color: view.tintColor, view: viewWithImage(named: "check"))
            
            cell.leftToRightAttr.viewBehavior = .DragWithPanThenStick
            cell.leftToRightAttr.color = greenColor
            cell.rightToLeftAttr.rubberbandBounce = false
        } else {
            let redColor = UIColor(red: 232.0/255.0, green: 61.0/255.0, blue: 14.0/255.0, alpha: 1.0)
            
            cell.setPanGesture(.LeftToRight, mode: .Switch, color: view.tintColor, view: viewWithImage(named: "check"))
            cell.setPanGesture(.RightToLeft, mode: .Exit, color: redColor, view: viewWithImage(named: "cross"))
            
            cell.rightToLeftAttr.triggerPercentage = 0.4
            cell.rightToLeftAttr.rubberbandBounce = true
            cell.rightToLeftAttr.viewBehavior = .DragWithPan
        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // Implement your own `tableView:didSelectRowAtIndexPath:` here.
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
        let listColor = [UIColor.greenColor(), UIColor.redColor(), UIColor.darkGrayColor()]
        let placeHolder = UIView(frame: CGRect(x:0,y: 0,width: viewWidth,height: 40))
        
        for (i,text) in buttons.enumerate() {
            let button = UIButton(type: .Custom)
            button.setTitle(text, forState: .Normal)
            button.frame = CGRect(x: 51*i, y: 0, width: 50, height: 40)
            button.backgroundColor = listColor[i % listColor.count]
            print("button color = \(button.backgroundColor)")
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
















