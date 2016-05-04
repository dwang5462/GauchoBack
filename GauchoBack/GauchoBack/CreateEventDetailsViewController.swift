//
//  CreateEventDetailsViewController.swift
//  GauchoBack
//
//  Created by Tristan T Starck on 5/3/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import UIKit

class CreateEventDetailsController : UIViewController{
    @IBOutlet weak var eventNameTextField: UITextField!
    
    @IBOutlet weak var hostTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextView!
    
    override func viewDidLoad() {
        print("Hello")
    }
    
    @IBAction func createEventAction(sender: AnyObject) {
        let eventName = eventNameTextField.text
        let host = hostTextField.text
        let location = locationTextField.text
        let description = descriptionTextField.text
        
        let newEvent = Event(eventName: eventName!, eventDescription: description, location: location!, longitude: "", latitude: "", startTime: "", endTime: "", author: CURRENT_USER.authData.uid, host: host!, eventType: "")
        let firebaseAdapter = FirebaseAdapter()
        
        firebaseAdapter.addEvent(newEvent)
    }
}