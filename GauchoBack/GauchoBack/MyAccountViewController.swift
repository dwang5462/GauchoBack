//
//  MyAccountViewController.swift
//  GauchoBack
//
//  Created by Carson Holoien on 5/3/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import UIKit
import FBSDKLoginKit

var myAccountEventList:[Event]!


class MyAccountViewController: UIViewController
{
    var firebaseAdapter:FirebaseAdapter!
    
    @IBOutlet weak var tableView: UITableView!
    
    var myEventsTable: NSMutableArray! = NSMutableArray()
    let settingsButton = UIButton()
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsButton.setImage(UIImage(named: "Settings"), forState: .Normal)
        settingsButton.frame = CGRectMake(0, 0, 30, 30)
        settingsButton.addTarget(self, action: Selector("action"), forControlEvents: .TouchUpInside)
        
        //.... Set Right/Left Bar Button item
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = settingsButton
        rightBarButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        
        //initialize the firebase adapter.
        
        firebaseAdapter = FirebaseAdapter()
        
        firebaseAdapter.myEvents()
        
        buildMyEventsTable()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        firebaseAdapter.myEvents()

        buildMyEventsTable()
        
        //If user is not already logged in then segue back to login page.
        
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") == nil || CURRENT_USER.authData == nil
        {
            performSegueWithIdentifier("backToLoginSegue", sender: self)
        }
    }
    
    func buildMyEventsTable()-> Void
    {
        if myAccountEventList != nil
        {
            print("My Account Event List is NOT empty.")
            for event in myAccountEventList {
                if myEventsTable.containsObject(event.eventName) == false
                {
                    self.myEventsTable.addObject(event.eventName)
                }
            }
        }
            
        else {
            print("My Account Event List is empty.")
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.myEventsTable.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("myEventCell", forIndexPath: indexPath) as! TableViewCell
        
        cell.eventTitle.text = (self.myEventsTable.objectAtIndex(indexPath.row) as! String)
        cell.eventTitle.text = " " + cell.eventTitle.text!
        cell.eventTitle.textColor = UIColor.whiteColor()
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.backgroundColor = UIColor.init(colorLiteralRed: 8/255, green: 44/255, blue: 101/255, alpha: 1)
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.performSegueWithIdentifier("myEventViewController", sender: self)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "myEventViewController")
        {
            var upcoming: MyEventViewController = segue.destinationViewController as! MyEventViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            let titleString = self.myEventsTable.objectAtIndex(indexPath.row) as? String
            
            upcoming.titleString = titleString
            
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
    }
    
    @IBAction func settingsAction(sender: AnyObject) {
        performSegueWithIdentifier("settingsSegue", sender: self)
    }
    
}
