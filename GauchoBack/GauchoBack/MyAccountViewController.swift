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
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize the firebase adapter.
        firebaseAdapter = FirebaseAdapter()
        
        firebaseAdapter.myEvents()
        
        buildMyEventsTable()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        
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
        
        cell.eventTitle.text = self.myEventsTable.objectAtIndex(indexPath.row) as? String
        
        
        
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
