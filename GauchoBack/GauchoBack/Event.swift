//
//  Event.swift
//  GauchoBack
//
//  Created by Carson Holoien on 5/4/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import Foundation



class Event:NSObject{
    
    var eventName: String{
        get{return self.eventName}
        set{self.eventName = newValue}
    }
    var eventDescription: String{
        get{return self.eventDescription}
        set{self.eventDescription = newValue}
    }
    var location:String{
        get{return self.location}
        set{self.location = newValue}
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
    var host:String{
        get{return self.host}
        set{self.host = newValue}
    }
    var eventType:String{
        get{return self.eventType}
        set{self.eventType = newValue}
    }
    
    
    init(eventName:String, eventDescription:String, location:String, longitude:String, latitude:String, startTime:String, endTime:String, author:String, host:String, eventType:String){
        super.init()
        self.eventName = eventName
        self.eventDescription = eventDescription
        self.location = location
        self.longitude = longitude
        self.latitude = latitude
        self.startTime = startTime
        self.endTime = endTime
        self.author = author
        self.host = host
        self.eventType = eventType
    }
    
    
    
}
