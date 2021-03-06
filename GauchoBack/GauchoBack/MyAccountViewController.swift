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
var mySubscribedEventList:[Event]!

class MyAccountViewController: UIViewController
{
    var firebaseAdapter:FirebaseAdapter!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedIndex: Int = 0

    let searchController = UISearchController(searchResultsController: nil)
    
    var eventMarker:Event!
    
    var thisEvent: Event!
    
    var myEventsTable: NSMutableArray! = NSMutableArray()
    
    let settingsButton = UIButton()
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize the firebase adapter.
        
        firebaseAdapter = FirebaseAdapter()
        firebaseAdapter.getSubscribedEvents()
        firebaseAdapter.myEvents()
        
        buildMyEventsTable()
        buildMySubscribedEventsTable()
        let userInfoBranch = FIREBASE_REF.childByAppendingPath("users").childByAppendingPath(CURRENT_USER.authData.uid).childByAppendingPath("user_info")
        
        //var userInfo:[String] = []
        
        userInfoBranch.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            
            print(snapshot.value.objectForKey("first_name") as! String!)
            
            let first = snapshot.value.objectForKey("first_name") as! String!
            let last = snapshot.value.objectForKey("last_name") as! String!
            
            self.navigationItem.title = first + " " + last
            self.emailLabel.text = snapshot.value.objectForKey("email") as! String!
            
            //userInfo.append(snapshot.value.objectForKey("email") as! String!)
        })

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        firebaseAdapter.getSubscribedEvents()
        firebaseAdapter.myEvents()
        
        buildMyEventsTable()
        buildMySubscribedEventsTable()
        //If user is not already logged in then segue back to login page.
        //print(firebaseAdapter.getUserInfo())
        
        //var userInfo:[String] = firebaseAdapter.getUserInfo()
        
        
        //let fullName = userInfo[0] + " " + userInfo[1]

        //self.userName.text = fullName
        
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") == nil || CURRENT_USER.authData == nil
        {
            performSegueWithIdentifier("backToLoginSegue", sender: self)
        }
        
        firebaseAdapter.getNearbyEvents(currentLongitude, currentLatitude: currentLattitude, maxDistance: maxDistance)
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
    
    func buildMySubscribedEventsTable()-> Void
    {
        if mySubscribedEventList != nil
        {
                print("SubscribedEvents!!!!!!")
        }
        print("Hello")
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
        print(indexPath.row)
        cell.eventTitle.text = myAccountEventList[indexPath.row].eventName
        cell.eventTitle.textColor = UIColor.whiteColor()
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.backgroundColor = UIColor.init(colorLiteralRed: 8/255, green: 44/255, blue: 101/255, alpha: 1)
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //tableView.cellForRowAtIndexPath(indexPath)
        
        var curEvent : Event
        
        curEvent = myAccountEventList[indexPath.row]
        selectedIndex = indexPath.row
        
        print(curEvent.eventName)
        
        thisEvent = curEvent
        self.performSegueWithIdentifier("myEventViewController", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var curEvent : Event!
        
        if (segue.identifier == "myEventViewController")
        {
            let upcoming: MyEventViewController = segue.destinationViewController as! MyEventViewController
  
            curEvent = myAccountEventList[selectedIndex]
            
            self.tableView.reloadData()
            upcoming.theEvent = thisEvent
            
        }
        
    }
    
    @IBAction func settingsButtonAction(sender: AnyObject) {        performSegueWithIdentifier("settingsSegue", sender: self)

    }
 
        
}
