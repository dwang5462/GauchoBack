//
//  Event.swift
//  GauchoBack
//
//  Created by Carson Holoien on 5/4/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import Foundation

class Event:NSObject{
    
    var eventName: String = ""
    var eventDescription: String = ""
    var location:String = ""
    var longitude:String = ""
    var latitude:String = ""
    var startTime:String = ""
    var endTime:String = ""
    var host:String = ""
    var eventType:String = ""
    var eventID: String = ""
    
    
    init(eventName:String, eventDescription:String, location:String, longitude:String, latitude:String, startTime:String, endTime:String, host:String, eventType:String, eventID:String){
        super.init()
        self.eventName = eventName
        self.eventDescription = eventDescription
        self.location = location
        self.longitude = longitude
        self.latitude = latitude
        self.startTime = startTime
        self.endTime = endTime
        self.host = host
        self.eventType = eventType
        self.eventID = eventID
    }
    init(eventName:String, eventDescription:String, location:String, longitude:String, latitude:String, startTime:String, endTime:String, host:String, eventType:String){
        super.init()
        self.eventName = eventName
        self.eventDescription = eventDescription
        self.location = location
        self.longitude = longitude
        self.latitude = latitude
        self.startTime = startTime
        self.endTime = endTime
        self.host = host
        self.eventType = eventType
    }

}
