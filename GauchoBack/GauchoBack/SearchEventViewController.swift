//
//  SearchEventViewController.swift
//  GauchoBack
//
//  Created by Carson Holoien on 5/4/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import UIKit
import Firebase



class SearchEventViewController:   UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    let firebaseAdapter = FirebaseAdapter()
    
    let searchController = UISearchController(searchResultsController: nil)
    var selectedIndex: Int = 0
    
    //Contains the items the user is searching for.
    var matchedEventsList = [Event!]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["Title","Description", "Host", "Location"]
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = ucsbGold
        searchController.searchBar.barTintColor = ucsbNavy
        definesPresentationContext = true
        
        self.tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        firebaseAdapter.getNearbyEvents(currentLongitude, currentLatitude: currentLattitude, maxDistance: maxDistance)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if searchController.active
        {
            return self.matchedEventsList.count
        }
        else
        {
            return allNearbyEvents.count
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("searchTableCell")! as UITableViewCell?
        
        var singleEvent : Event
        
        if searchController.active
        {
            singleEvent = self.matchedEventsList[indexPath.row] as Event
        }
        else
        {
            singleEvent = allNearbyEvents[indexPath.row]
        }
        
        cell!.textLabel?.text = singleEvent.eventName
        
        return cell!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var curEvent : Event
        
        
        if searchController.active
        {
            curEvent = self.matchedEventsList[indexPath.row] as Event
            selectedIndex = indexPath.row
        }
        else
        {
            curEvent = allNearbyEvents[indexPath.row] as Event
            selectedIndex = indexPath.row
        }
        
        print("table view event")
        print(curEvent.eventName)
        
        self.performSegueWithIdentifier("eventDetailViewController", sender: self)
        
    }
    
    
    //refresh search results when search scope changes.
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResultsForSearchController(searchController)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        matchedEventsList.removeAll(keepCapacity: false)
        
        let scope = searchController.searchBar.selectedScopeButtonIndex
        print(scope)
        
        
        searchEvents(searchController.searchBar.text!, searchFilter: scope)
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //This function Returns an array of events that match a certain keyword.
    func searchEvents(keyword:String, searchFilter:Int) -> Void
    {
        matchedEventsList.removeAll()
        print("matches:")
            for event in allNearbyEvents
            {
                var match: Bool = false
                
                //switch is dependent on search type
                switch (searchFilter) {
                    
                //For each case we initialize the pertaining variable and check if the keyword exists.
                case 0:
                    let eventName = event.eventName
                    if eventName.rangeOfString(keyword) != nil
                    {
                        match = true
                        print("name ", eventName)
                    }
                    break;
                    
                case 1:
                    let eventDescription = event.eventDescription
                    if eventDescription.rangeOfString(keyword) != nil
                    {
                        match = true
                        print("description ", eventDescription)
                    }
                    break;
                    
                case 2:
                    let host = event.host
                    if host.rangeOfString(keyword) != nil
                    {
                        match = true
                        print("host ", host)
                    }
                    break;
                    
                case 3:
                    let location = event.location
                    if location.rangeOfString(keyword) != nil
                    {
                        match = true
                        print("location ", location)
                    }
                    break;
                 /*
                case "startTime":
                    let startTime = event.startTime
                    if startTime.rangeOfString(keyword) != nil
                    {
                        match = true
                    }
                    break;
                
                case "eventType":
                    let eventType = child.value.objectForKey("event_type") as! String!
                    if eventType.rangeOfString(keyword) != nil
                    {
                        match = true
                    }
                    break;
                */
                default:
                    break;
                }
                if match
                {
                    self.matchedEventsList.append(event)
                    
                }
                //else don't add event
            }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var curEvent : Event
        
        if (segue.identifier == "eventDetailViewController")
        {
            let upcoming: EventDetailViewController = segue.destinationViewController as! EventDetailViewController
            
            for event in self.matchedEventsList
            {
                print(event.eventName)
            }
            if searchController.active
            {
                curEvent = self.matchedEventsList[selectedIndex] as Event
                print("active")
            }
            else
            {
                curEvent = allNearbyEvents[selectedIndex] as Event
                print("inactive")
            }
            
            print("cur event detail")
            print(curEvent.eventName)
            
            //upcoming.titleString = curEvent.eventName
            self.tableView.reloadData()
            upcoming.theEvent = curEvent
            
        }
        
    }

}
