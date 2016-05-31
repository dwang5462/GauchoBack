//
//  MyEventViewController.swift
//  GauchoBack
//
//  Created by Carson Holoien on 5/17/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import UIKit
import GoogleMaps

class MyEventViewController: UIViewController {

    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var hostLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var hostTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    
    var tempBarButton: UIBarButtonItem!
    
    var eventRef: String!
    
    @IBOutlet weak var mapView: GMSMapView!
    var cam:GMSCameraPosition! = nil

    
    var theEvent: Event!
    
    //var editButton: UIBarButtonItem
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cam = GMSCameraPosition.cameraWithLatitude(CLLocationDegrees(theEvent.latitude)!, longitude: CLLocationDegrees(theEvent.longitude)!, zoom: 17)
        mapView.camera = cam
        let marker = GMSMarker()
        marker.map = mapView
        marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(theEvent.latitude)!, longitude: CLLocationDegrees(theEvent.longitude)!)
        marker.snippet = theEvent.eventName
        marker.appearAnimation = kGMSMarkerAnimationPop
        if(theEvent.eventType == "warning"){
            marker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
        }
        else if(theEvent.eventType == "event"){
            marker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
        }
        else{
            marker.icon = GMSMarker.markerImageWithColor(UIColor.yellowColor())
        }
        eventNameTextField.text! = theEvent.eventName
        hostTextField.text! = theEvent.host
        locationTextField.text! = theEvent.location
        startTimeTextField.text! = theEvent.startTime
        endTimeTextField.text! = theEvent.endTime
        eventDescriptionTextView.text! = theEvent.eventDescription
        //self.eventTitle.text = theEvent.eventName
        self.navigationItem.title = theEvent.eventName
        // Do any additional setup after loading the view.
        
        //editButton.image =
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func editButtonAction(sender: AnyObject) {
        tempBarButton = self.navigationItem.rightBarButtonItem!
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(MyEventViewController.saveInfo(_:)))
        
        eventNameTextField.enabled = true
        hostTextField.enabled = true
        startTimeTextField.enabled = true
        endTimeTextField.enabled = true
        eventDescriptionTextView.editable = true
        
        eventNameTextField.borderStyle = UITextBorderStyle.Bezel
        hostTextField.borderStyle = UITextBorderStyle.Bezel
        startTimeTextField.borderStyle = UITextBorderStyle.Bezel
        endTimeTextField.borderStyle = UITextBorderStyle.Bezel
        eventDescriptionTextView.layer.borderWidth = 1.0
        eventDescriptionTextView.layer.borderColor = UIColor.blackColor().CGColor
        
        print("edit button pressed")
    }
    
    
    func saveInfo(sender: AnyObject){
        
        self.navigationItem.rightBarButtonItem = tempBarButton
        
        theEvent.eventName = eventNameTextField.text!
        theEvent.host = hostTextField.text!
        theEvent.startTime = startTimeTextField.text!
        theEvent.endTime = endTimeTextField.text!
        theEvent.eventDescription = eventDescriptionTextView.text!
        
        let firebaseAdapter = FirebaseAdapter()
        
        firebaseAdapter.editEvent(theEvent)
        
        eventNameTextField.enabled = false
        hostTextField.enabled = false
        startTimeTextField.enabled = false
        endTimeTextField.enabled = false
        eventDescriptionTextView.editable = false
        
        eventNameTextField.borderStyle = UITextBorderStyle.None
        hostTextField.borderStyle = UITextBorderStyle.None
        startTimeTextField.borderStyle = UITextBorderStyle.None
        endTimeTextField.borderStyle = UITextBorderStyle.None
        eventDescriptionTextView.layer.borderWidth = 0.0
        eventDescriptionTextView.layer.borderColor = UIColor.blackColor().CGColor
        
        self.navigationItem.title = theEvent.eventName

        print("save button pressed")
        
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
