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
    
    
    //@IBOutlet weak var searchTableView: UITableView!
    
    var resultSearchController = UISearchController()
    
    let searchController = UISearchController(searchResultsController: nil)
    var selectedIndex: Int = 0
    var searchResults: Bool = false
    
    //Contains the items the user is searching for.
    var matchedEventsList = [Event!]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["Title","Descriiption", "Host", "Location"]
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        
        self.tableView.tableHeaderView = searchController.searchBar
        
        //In default, we will have all nearby events in the matched array.
        //matchedEventsList = allNearbyEvents
        
        self.tableView.reloadData()
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
            //searchDisplayController?.searchResultsTableView)
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
        
        if (self.resultSearchController.active)
        {
            curEvent = self.matchedEventsList[indexPath.row] as Event
            selectedIndex = indexPath.row
            searchResults = true
        }
        else
        {
            curEvent = allNearbyEvents[indexPath.row] as Event
            selectedIndex = indexPath.row
            searchResults = false
        }
        
        print(curEvent.eventName)
        
        self.performSegueWithIdentifier("eventDetailViewController", sender: self)
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var curEvent : Event

        if (segue.identifier == "eventDetailViewController")
        {
            let upcoming: EventDetailViewController = segue.destinationViewController as! EventDetailViewController
            
            
            if searchResults
            {
                curEvent = self.matchedEventsList[selectedIndex] as Event
            }
            else
            {
                curEvent = allNearbyEvents[selectedIndex] as Event
            }
     
            print(curEvent.eventName)
            
            upcoming.titleString = curEvent.eventName
            
            upcoming.theEvent = curEvent
            
            //self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
    }

    
    //refresh search when search type updates.
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResultsForSearchController(searchController)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        matchedEventsList.removeAll(keepCapacity: false)
        
        let scope = searchController.searchBar.selectedScopeButtonIndex
        
    
        //let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        //searchPredicate is the search text
        print(scope)
        
        
        searchEvents(searchController.searchBar.text!, searchFilter: scope)
        
        //let array = matchedEventsList as NSArray
        
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
            
            
            //iterate over the all the children of the events branch
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
                    matchedEventsList.append(event)
                    
                }
                //else don't add event
            }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
