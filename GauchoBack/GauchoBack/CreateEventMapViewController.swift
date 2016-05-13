//
//  CreateEventMapViewController.swift
//  GauchoBack
//
//  Created by Tristan T Starck on 5/3/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import UIKit
import GoogleMaps

class CreateEventMapController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UIAlertViewDelegate{
    var locationManager = CLLocationManager()
    
    var cam:GMSCameraPosition! = nil
    var userLocation:CLLocation!
    var eventCoordinate:CLLocationCoordinate2D!
    var eventType:String!
    var eventMarker:GMSMarker!
    @IBOutlet var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //If user is not already logged in then segue back to login page.
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") == nil || CURRENT_USER.authData == nil
        {
            performSegueWithIdentifier("addEventAttemptNoAccountSegue", sender: self)
        }
        
        //Need to delete where the pin is.
        //print("this happened")
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        userLocation = locations[0]
        
        //print(userLocation)
        if(cam == nil){
            cam = GMSCameraPosition.cameraWithTarget(userLocation.coordinate, zoom: 18)
            //mapView = GMSMapView.mapWithFrame(CGRectZero, camera: cam)
            mapView.camera = cam
            mapView.myLocationEnabled = true
            mapView.delegate = self
            mapView.settings.myLocationButton = true
            mapView.accessibilityElementsHidden = false
            /*let marker = GMSMarker()
             marker.position = cam.target
             marker.snippet = "Hello World"
             marker.appearAnimation = kGMSMarkerAnimationPop
             marker.map = mapView
             */
            /*
             let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
             uilpgr.minimumPressDuration = 2
             mapView.addGestureRecognizer(uilpgr)
             
             */
            // self.subViewMap = mapView
        }
        else{
            /*let cameraUpdate = GMSCameraPosition.cameraWithTarget(userLocation.coordinate, zoom: 15)
             let update = GMSCameraUpdate.setCamera(cameraUpdate)
             mapView.moveCamera(update)*/
            
            
        }
        
        
    }
    
    func mapView(mapView: GMSMapView, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D){
        print("Did it work?")
        eventMarker = GMSMarker()
        eventMarker.map = mapView
        eventMarker.position = coordinate
        eventMarker.snippet = "Hello World"
        eventMarker.appearAnimation = kGMSMarkerAnimationPop
        eventCoordinate = coordinate
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Choose Type", message: "Blue for Event\nYellow for Meeting\nRed for Warning\n", preferredStyle: .ActionSheet)
        
        // Create the actions
        let warningAction = UIAlertAction(title: "Warning", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.eventMarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
            self.eventType = "warning"
            self.performSegueWithIdentifier("eventCreator", sender: self)
        }
        let eventAction = UIAlertAction(title: "Event", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.eventMarker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
            self.eventType = "event"
            self.performSegueWithIdentifier("eventCreator", sender: self)
        }
        let meetingAction = UIAlertAction(title: "Meeting", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.eventMarker.icon = GMSMarker.markerImageWithColor(UIColor.yellowColor())
            self.eventType = "meeting"
            self.performSegueWithIdentifier("eventCreator", sender: self)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            self.eventMarker.map = nil
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(eventAction)
        alertController.addAction(meetingAction)
        alertController.addAction(warningAction)
        alertController.view.alpha = 0.91
        //alertController.view.tintColor = UIColor.redColor()
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "eventCreator") {
            self.eventMarker.map = nil
            let yourNextViewController = (segue.destinationViewController as! CreateEventDetailsController)
            yourNextViewController.eventCoordinate = eventCoordinate
            yourNextViewController.eventType = eventType
        }
    }
}

