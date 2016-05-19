//
//  FirebaseInterface.swift
//  GauchoBack
//
//  Created by Carson Holoien on 4/27/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import Foundation
import Firebase

class FirebaseAdapter {
    var eventList:[Event]!
    
    let eventsBranch = FIREBASE_REF.childByAppendingPath("events")
    let usersBranch = FIREBASE_REF.childByAppendingPath("users")
    
    
    //Returns user's "firstName" at index 0, "lastName"  at index 1 and "email" at index 2
    func getUserInfo() -> [String]{
        
        let userInfoBranch = usersBranch.childByAppendingPath(CURRENT_USER.authData.uid).childByAppendingPath("user_info")
        
        var userInfo:[String] = []
        
        userInfoBranch.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            
            userInfo.append(snapshot.value.objectForKey("first_name") as! String!)
            userInfo.append(snapshot.value.objectForKey("last_name") as! String!)
            userInfo.append(snapshot.value.objectForKey("email") as! String!)
        })

        
        return userInfo
    }
    
    
    //Sets user info on firebase.
    func setUserInfo(firstName:String, lastName:String, email: String) -> Void{
        
        let userInfoBranch = usersBranch.childByAppendingPath(CURRENT_USER.authData.uid).childByAppendingPath("user_info")
        let userInfoDict = ["first_name": firstName, "last_name" :lastName, "email" : email]
        
        //saving info at user info location
        userInfoBranch.setValue(userInfoDict)
    }
    
    
   //Adds an event to the events branch
    func addEvent(newEvent:Event)-> Void
    {
        //"author" is strictly used only in addEvent and MyEvents.  It will be used whenever we create events or look for events made by current user.
        let newEventDict = ["event_name" : newEvent.eventName, "event_description" : newEvent.eventDescription, "start_time" : newEvent.startTime,"longitude":newEvent.longitude, "latitude":newEvent.latitude,  "end_time" : newEvent.endTime, "author": CURRENT_USER.authData.uid, "event_host": newEvent.host, "location":newEvent.location, "event_type" : newEvent.eventType]
        
        //create a new branch off the events branch for this new event, to hold the newEvent dictionary
        let newEventBranch = eventsBranch.childByAutoId()
        
        //save the event at the newEventBranch
        newEventBranch.setValue(newEventDict)
        
    }

    //This function Returns an array of events that match a certain keyword.
    func searchEvents(keyword:String, searchType:String) -> [Event]
    {
        var matchedEvents = [Event]()
        
        print("Matching by ", searchType)
     
        eventsBranch.observeSingleEventOfType(.Value, withBlock:{snapshot in
     
            //initialize the iterator object
            let enumerator = snapshot.children
            
            //iterate over the all the children of the events branch
            while let child = enumerator.nextObject() as? FDataSnapshot
            {
                var match: Bool = false
                
                //switch is dependent on search type
                switch (searchType) {
                    
                    //For each case we initialize the pertaining variable and check if the keyword exists.
                    case "eventName":
                        let eventName = child.value.objectForKey("event_name") as! String!
                        if eventName.rangeOfString(keyword) != nil
                        {
                            match = true
                        }
                        break;
                    
                    case "description":
                        let eventDescription = child.value.objectForKey("event_description") as! String!
                        if eventDescription.rangeOfString(keyword) != nil
                        {
                            match = true
                        }
                        break;
                    
                    case "host":
                        let host = child.value.objectForKey("event_host") as! String!
                        if host.rangeOfString(keyword) != nil
                        {
                            match = true
                        }
                        break;
                    
                    case "location":
                        let location = child.value.objectForKey("location") as! String!
                        if location.rangeOfString(keyword) != nil
                        {
                            match = true
                        }
                        break;
                    
                    case "startTime":
                        let startTime = child.value.objectForKey("start_time")as! String!
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
                    
                    default:
                        break;
                }
                if match
                {
                    print("Match Found")
                    let eventName = child.value.objectForKey("event_name") as! String!
                    let eventDescription = child.value.objectForKey("event_description") as! String!
                    let host = child.value.objectForKey("event_host") as! String!
                    let location = child.value.objectForKey("location") as! String!
                    let startTime = child.value.objectForKey("start_time")as! String!
                    let eventType = child.value.objectForKey("event_type") as! String!
                    let longitude = child.value.objectForKey("longitude")as! String!
                    let latitude = child.value.objectForKey("latitude")as! String!
                    let endTime = child.value.objectForKey("end_time")as! String!

                    matchedEvents.append(Event(eventName: eventName, eventDescription: eventDescription,location:location, longitude: longitude, latitude: latitude, startTime: startTime, endTime: endTime, host: host, eventType:eventType))
                }
                //else don't add event
            }
        })
    
        return matchedEvents
    }
 
    //This function retrieves the events that pertain to the user.  This will be used when the user enters the "MyAccount" tab.
    //Returns an array of events that the user has created.
    func myEvents()-> Void
    {
        
        var myEvents = [Event]()
        
        eventsBranch.observeSingleEventOfType(.Value, withBlock:{snapshot in
        
            let enumerator = snapshot.children
            
            //iterate over the all the children of the events branch
            while let child = enumerator.nextObject() as? FDataSnapshot
            {
                let eventAuthor = child.value.objectForKey("author") as! String!
                
                //if the author of the event matches the current author
                if eventAuthor == CURRENT_USER.authData.uid
                {
                    
                    let eventName = child.value.objectForKey("event_name") as! String!
                    let eventDescription = child.value.objectForKey("event_description") as! String!
                    let longitude = child.value.objectForKey("longitude")as! String!
                    let latitude = child.value.objectForKey("latitude")as! String!
                    let startTime = child.value.objectForKey("start_time")as! String!
                    let endTime = child.value.objectForKey("end_time")as! String!
                    let location = child.value.objectForKey("location") as! String!
                    let eventType = child.value.objectForKey("event_type") as! String!
                    let host = child.value.objectForKey("event_host") as! String!
                    
                    //print("found event ", eventName)
                    
                    myEvents.append(Event(eventName: eventName, eventDescription: eventDescription, location:location, longitude: longitude, latitude: latitude, startTime: startTime, endTime: endTime, host:host, eventType: eventType))

                }
            }
            //print(myEvents)
            myAccountEventList =  myEvents
            
        })
       // return myEvents
    }
    
    //get all nearby events to user's current location, based on maximum distance away.
    func getNearbyEvents(currentLongitude:String, currentLatitude:String, maxDistance:Double) -> [Event]
    {
        
        var nearbyEvents = [Event]()
        eventsBranch.observeSingleEventOfType(.Value, withBlock:{snapshot in
            
            let enumerator = snapshot.children
            
            //iterate over the all the children of the events branch
            while let child = enumerator.nextObject() as? FDataSnapshot
            {
                let eventLongitude = child.value.objectForKey("longitude")as! String!
                let eventLatitude = child.value.objectForKey("latitude")as! String!
                
                let longitudeDelta = abs(Double(currentLongitude)! - Double(eventLongitude)!) as Double!
                let latitudeDelta = abs(Double(currentLatitude)! - Double(eventLatitude)!) as Double!
                
                
                let distanceAway = sqrt((longitudeDelta * longitudeDelta) + (latitudeDelta * latitudeDelta))
                
                //if distance away from current loaction is within maximum distance
                if distanceAway <= maxDistance
                {
                    let eventName = child.value.objectForKey("event_name") as! String!
                    let eventDescription = child.value.objectForKey("event_description") as! String!
                    let location = child.value.objectForKey("location") as! String!
                    //let startTime = child.value.objectForKey("start_time")as! String!
                    let startTime = "3:00"
                    let endTime = "3:00"
                    //let endTime = child.value.objectForKey("end_time")as! String!
                    let host = child.value.objectForKey("event_host") as! String!
                    let eventType = child.value.objectForKey("event_type") as! String!
                    //add event to event list
                    nearbyEvents.append(Event(eventName: eventName, eventDescription: eventDescription, location: location, longitude: eventLongitude, latitude: eventLatitude, startTime: startTime, endTime: endTime, host: host, eventType:eventType))
                }
            }
            nearbyEventsMapView = nearbyEvents
        })
        
        return nearbyEvents
    }
    
    
    /*
    func deleteEvent()->
    {
        
    }
 */
    
    //Removes all characters from strings that firebase does not allow for branch names.
    func removeIllegalChars(input:String)->String
    {
        var input = input.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range:nil)
        input = input.stringByReplacingOccurrencesOfString("#", withString: "", options: NSStringCompareOptions.LiteralSearch, range:nil)
        input = input.stringByReplacingOccurrencesOfString("$", withString: "", options: NSStringCompareOptions.LiteralSearch, range:nil)
        input = input.stringByReplacingOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.LiteralSearch, range:nil)
        input = input.stringByReplacingOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.LiteralSearch, range:nil)
        
        return input
    }
   
    //Returns true if an email exists in our system, false if not.
    func doesUserExist(emailToCheck:String)->Bool
    {
        let emailToCheck = removeIllegalChars(emailToCheck)
        
        var exists: Bool = false
        
        let accountsBranch = FIREBASE_REF.childByAppendingPath("accounts")
        
        accountsBranch.observeEventType(.Value, withBlock:
            { snapshot  in
                
                if snapshot.hasChild(emailToCheck)
                {
                    print("child found")
                    exists = true
                }
                else{
                    //create an account
                }
            }, withCancelBlock: {error in
                print(error.description)
        })
        
        return exists
    }
    
    //Add account to our list of accounts.
    func addAccount(email:String)->Void
    {
        let email = removeIllegalChars(email)
        let addedAccount = ["added": true]
        FIREBASE_REF.childByAppendingPath("accounts").childByAppendingPath(email).setValue(addedAccount)
    }

}
