//
//  FirebaseInterface.swift
//  GauchoBack
//
//  Created by Carson Holoien on 4/27/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import Foundation
import Firebase
import Event

class FirebaseAdapter {
    
    
    //Base if you are not logged in.
    
    var eventRef = FIREBASE_REF.childByAppendingPath("events")
    
    var usersRef = FIREBASE_REF.childByAppendingPath("users")
    
    
    func getUserInfo() -> [String]{
        //let userInfoRef = FIREBASE_REF.childByAppendingPath("users").childByAppendingPath(CURRENT_USER.authData.uid).childByAppendingPath("user_info")
        let userInfo:[String] = ["empty"]
        
        
        
        return userInfo
    }
    
    
    //Sets user info using a string array
    func setUserInfo(firstName:String, lastName:String, email: String) -> Void{
        
        let userInfoRef = FIREBASE_REF.childByAppendingPath("users").childByAppendingPath(CURRENT_USER.authData.uid).childByAppendingPath("user_info")
        let userInfoDict = ["first_name": firstName, "last_name" :lastName, "email" : email]
        
        //saving info at user info location
        userInfoRef.setValue(userInfoDict)
    }
    
    //Removes all characters from email address that firebase does not allow for chil names.
    func removeBadChars(email:String)->String
    {
        var email = email.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range:nil)
        email = email.stringByReplacingOccurrencesOfString("#", withString: "", options: NSStringCompareOptions.LiteralSearch, range:nil)
        email = email.stringByReplacingOccurrencesOfString("$", withString: "", options: NSStringCompareOptions.LiteralSearch, range:nil)
        email = email.stringByReplacingOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.LiteralSearch, range:nil)
        email = email.stringByReplacingOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.LiteralSearch, range:nil)

        return email
    }
    
    //Returns true if an email exists in our system, false if not.
    func doesUserExist(emailToCheck:String)->Bool
    {
        let emailToCheck = removeBadChars(emailToCheck)
        
        var exists: Bool = false
        
        let accountRef = FIREBASE_REF.childByAppendingPath("accounts")
        
        accountRef.observeEventType(.Value, withBlock:
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
    
    
   
    func addEvent(eventName:String, eventDescription:String,longitude:String, latitude:String, startTime:String, endTime:String)-> Void
    {
        let newEvent = ["event_name" : eventName, "event_description" : eventDescription, "start_time" : startTime,"longitude":longitude, "latitude":latitude,  "end_time" : endTime, "author": CURRENT_USER.authData.uid]
        
        let eventsBranch = FIREBASE_REF.childByAppendingPath("events").childByAutoId()
        
        eventsBranch.setValue(newEvent)
        
        /*
        var eventName:String = ""
        
        var backslashCounter = 0
        
        for var i = currentBranch.characters.count; i >= 0; i -= 1
        {
            
            if currentBranch[i] == "/"  {
                backslashCounter = backslashCounter + 1
            }
            if backslashCounter > 1 {
                eventName = eventName + currentBranch.
            }
        }
        
        */
        
    }
    
    //This function retrieves a list of events that match a certain keyword.
    func searchEvents(keyword:String) -> [Event]
    {
        var matchedEvents = [Event]()
        
        
        var eventsBranch = FIREBASE_REF.childByAppendingPath("events")
        
        eventsBranch.once("value", function(snapshot)
        {
            
            snapshot.forEach(function(childSnapshot)
            {
                
                let eventName = childSnapshot.valueForKey("event_name")
                let eventDescription = childSnapshot.valueForKey("event_description")
                let longitude = childSnapshot.valueForKey("longitude")
                let latitude = childSnapshot.valueForKey("latitude")
                let startTime = childSnapshot.valueForKey("start_time")
                let endTime = childSnapshot.valueForKey("end_time")
                
                if eventName.rangeOfString(keyword) != nil || eventDescription.rangeOfString(keyword) != nil
                {
                    let matchedEvent = Event(eventName: eventName, eventDescription: eventDescription, longitude: longitude, latitude: latitude, startTime: startTime, endTime: endTime)
                    
                    matchedEvents.append(matchEvent)

                }
                
                });
            });
        
    
        return matchedEvents
    }
    
    //This function retrieves the events that pertain to the user.  This will be used when the user enters the "MyAccount" tab.
    func usersEvents(){
        
        var usersEvents = [Event]()
        
        
        var eventsBranch = FIREBASE_REF.childByAppendingPath("events")
        
        eventsBranch.once("value", function(snapshot)
        {
            
            snapshot.forEach(function(childSnapshot)
            {
                
                let eventName = childSnapshot.valueForKey("event_name") as! String!
                let eventDescription = childSnapshot.valueForKey("event_description")
                let longitude = childSnapshot.valueForKey("longitude")
                let latitude = childSnapshot.valueForKey("latitude")
                let startTime = childSnapshot.valueForKey("start_time")
                let endTime = childSnapshot.valueForKey("end_time")
                let author = childSnapshot.valueForKey("author")
                
                if author == CURRENT_USER.authData.uid
                {
                    let matchedEvent = Event(eventName: eventName, eventDescription: eventDescription, longitude: longitude, latitude: latitude, startTime: startTime, endTime: endTime)
                    
                    usersEvents.append(matchEvent)
                    
                }
                
                });
            });
        
        
        return matchedEvents
    }

    
    /*
    func deleteEvent()->
    {
        
    }
 */
}


class Event{
    
    var eventName: String{
        get{return eventName}
    }
    var eventDescription: String{
        get{return eventDescription}
    }
    var longitude:String{
        get{return longitude}
    }
    var latitude:String{
        get{return latitude}
    }
    var startTime:String{
        get{return startTime}
    }
    var endTime:String{
        get{return endTime}
    }
    var author:String{
        get{return author}
    }
    
    
    init(eventName:String, eventDescription:String,longitude:String, latitude:String, startTime:String, endTime:String){
        self.eventName = eventName
        self.eventDescription = eventDescription
        self.longitude = longitude
        self.latitude = latitude
        self.startTime = startTime
        self.endTime = endTime
        self.author = CURRENT_USER.authData.uid
    }
    
    
    
}
