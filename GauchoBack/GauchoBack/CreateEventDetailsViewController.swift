//
//  CreateEventDetailsViewController.swift
//  GauchoBack
//
//  Created by Tristan T Starck on 5/3/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import UIKit
import GoogleMaps

class CreateEventDetailsController : UIViewController, UITextFieldDelegate, UITextViewDelegate{
    @IBOutlet weak var eventNameTextField: UITextField!
    
    @IBOutlet weak var hostTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextView!
    
    @IBOutlet weak var startTimeTextField: UITextField!
    
    @IBOutlet weak var endTimeTextField: UITextField!
    
    var eventCoordinate:CLLocationCoordinate2D!
    var eventType:String!
    
    override func viewDidLoad() {
        hostTextField.delegate = self
        locationTextField.delegate = self
        eventNameTextField.delegate = self
    }
    
    @IBAction func createEventAction(sender: AnyObject) {
        
        let eventName = eventNameTextField.text
        let host = hostTextField.text
        let location = locationTextField.text
        let description = descriptionTextField.text
        let longitude = String(eventCoordinate.longitude)
        let latitude = String(eventCoordinate.latitude)
        let startTime = startTimeTextField.text
        let endTime = endTimeTextField.text
        let newEvent = Event(eventName: eventName!, eventDescription: description, location: location!, longitude: longitude, latitude: latitude, startTime: startTime!, endTime: endTime!, host: host!, eventType: eventType!)
        let firebaseAdapter = FirebaseAdapter()
        
        firebaseAdapter.addEvent(newEvent)
        
        performSegueWithIdentifier("eventCreatedSegue", sender: self)
        
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}