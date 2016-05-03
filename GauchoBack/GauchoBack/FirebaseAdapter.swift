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
    
    let eventsBranch = FIREBASE_REF.childByAppendingPath("events")
    let usersBranch = FIREBASE_REF.childByAppendingPath("users")
    
    //returns userinfo from firebase, in a string array.
    func getUserInfo() -> [String]{
        
        let userInfoBranch = usersBranch.childByAppendingPath(CURRENT_USER.authData.uid).childByAppendingPath("user_info")
        
        let userInfo:[String] = ["empty"]
        
        
        
        return userInfo
    }
    
    
    //Sets user info on firebase.
    func setUserInfo(firstName:String, lastName:String, email: String) -> Void{
        
        let userInfoBranch = usersBranch.childByAppendingPath(CURRENT_USER.authData.uid).childByAppendingPath("user_info")
        let userInfoDict = ["first_name": firstName, "last_name" :lastName, "email" : email]
        
        //saving info at user info location
        userInfoBranch.setValue(userInfoDict)
    }
    
    //Removes all characters from strings that firebase does not allow for branch names.
    func removeBadChars(input:String)->String
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
        let emailToCheck = removeBadChars(emailToCheck)
        
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
        let email = removeBadChars(email)
        let addedAccount = ["added": true]
        FIREBASE_REF.childByAppendingPath("accounts").childByAppendingPath(email).setValue(addedAccount)
    }
    
    
   //Adds an event to the events branch
    func addEvent(newEvent:Event)-> Void
    {
        let newEventDict = ["event_name" : newEvent.eventName, "event_description" : newEvent.eventDescription, "start_time" : newEvent.startTime,"longitude":newEvent.longitude, "latitude":newEvent.latitude,  "end_time" : newEvent.endTime, "author": CURRENT_USER.authData.uid]
        
        //create a new branch off the events branch for this new event, to hold the newEvent dictionary
        let newEventBranch = eventsBranch.childByAutoId()
        
        //save the event at the newEventBranch
        newEventBranch.setValue(newEventDict)
        
    }

    //This function Returns an array of events that match a certain keyword.
    func searchEvents(keyword:String) -> [Event]
    {
        var matchedEvents = [Event]()
     
        eventsBranch.observeSingleEventOfType(.Value, withBlock:{snapshot in
     
            //initialize the iterator object
            let enumerator = snapshot.children
            
            //iterate over the all the children of the events branch
            while let child = enumerator.nextObject() as? FDataSnapshot
            {
                let eventName = child.valueForKey("event_name") as! String!
                let eventDescription = child.valueForKey("event_description") as! String!

                //if keyword is a substring of the event name or the event description
                if eventName.rangeOfString(keyword) != nil || eventDescription.rangeOfString(keyword) != nil
                {
                    let longitude = child.valueForKey("longitude")as! String!
                    let latitude = child.valueForKey("latitude")as! String!
                    let startTime = child.valueForKey("start_time")as! String!
                    let endTime = child.valueForKey("end_time")as! String!
                    let author = child.valueForKey("author")as! String!
     
                    matchedEvents.append(Event(eventName: eventName, eventDescription: eventDescription, longitude: longitude, latitude: latitude, startTime: startTime, endTime: endTime, author: author))
                }
            }
        })
    
        return matchedEvents
    }
 
    
    //This function retrieves the events that pertain to the user.  This will be used when the user enters the "MyAccount" tab.
    //Returns an array of events that the user has created.
    func myEvents()->[Event]
    {
        
        var myEvents = [Event]()
        
        eventsBranch.observeSingleEventOfType(.Value, withBlock:{snapshot in
        
            let enumerator = snapshot.children
            
            //iterate over the all the children of the events branch
            while let child = enumerator.nextObject() as? FDataSnapshot
            {
                let eventAuthor = child.valueForKey("author") as! String!
                
                //if the author of the event matches the current author
                if eventAuthor == CURRENT_USER.authData.uid
                {
                    
                    let eventName = child.valueForKey("event_name") as! String!
                    let eventDescription = child.valueForKey("event_description") as! String!
                    let longitude = child.valueForKey("longitude")as! String!
                    let latitude = child.valueForKey("latitude")as! String!
                    let startTime = child.valueForKey("start_time")as! String!
                    let endTime = child.valueForKey("end_time")as! String!
                    
                    myEvents.append(Event(eventName: eventName, eventDescription: eventDescription, longitude: longitude, latitude: latitude, startTime: startTime, endTime: endTime, author: eventAuthor))
                }
            }
        })
        
        return myEvents
    }

    
    /*
    func deleteEvent()->
    {
        
    }
 */
}


class Event{
    
    var eventName: String{
        get{return self.eventName}
        set{self.eventName = newValue}
    }
    var eventDescription: String{
        get{return self.eventDescription}
        set{self.eventDescription = newValue}
    }
    var longitude:String{
        get{return self.longitude}
        set{self.longitude = newValue}
    }
    var latitude:String{
        get{return self.latitude}
        set{self.latitude = newValue}
    }
    var startTime:String{
        get{return self.startTime}
        set{self.startTime = newValue}
    }
    var endTime:String{
        get{return self.endTime}
        set{self.endTime = newValue}
        
    }
    var author:String{
        get{return self.author}
        set{self.author = newValue}
    }
    
    
    init(eventName:String, eventDescription:String,longitude:String, latitude:String, startTime:String, endTime:String, author:String){
        self.eventName = eventName
        self.eventDescription = eventDescription
        self.longitude = longitude
        self.latitude = latitude
        self.startTime = startTime
        self.endTime = endTime
        self.author = author
    }
    
    
    
}
