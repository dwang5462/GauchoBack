//
//  CreateEventDetailsViewController.swift
//  GauchoBack
//
//  Created by Tristan T Starck on 5/3/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import UIKit
import GoogleMaps

class CreateEventDetailsController : UIViewController{
    @IBOutlet weak var eventNameTextField: UITextField!
    
    @IBOutlet weak var hostTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextView!
    
    var eventCoordinate:CLLocationCoordinate2D!
    var eventType:String!
    override func viewDidLoad() {
        print("Hello")
    }
    
    @IBAction func createEventAction(sender: AnyObject) {
        
        let eventName = eventNameTextField.text
        let host = hostTextField.text
        let location = locationTextField.text
        let description = descriptionTextField.text
        let longitude = String(eventCoordinate.longitude)
        let latitude = String(eventCoordinate.latitude)
        let newEvent = Event(eventName: eventName!, eventDescription: description, location: location!, longitude: longitude, latitude: latitude, startTime: "", endTime: "", host: host!, eventType: eventType!)
        let firebaseAdapter = FirebaseAdapter()
        
        firebaseAdapter.addEvent(newEvent)
        
        performSegueWithIdentifier("eventCreatedSegue", sender: self)
    }
}