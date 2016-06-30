//
//  MapViewController.swift
//  GauchoBack
//
//  Created by Carson Holoien on 4/19/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import UIKit
import GoogleMaps
var allNearbyEvents:[Event]!
var currentLongitude: String!
var currentLattitude: String!

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var locationManager = CLLocationManager()
    var userLocation = CLLocation()
    var markersPlaced = false
    var cam:GMSCameraPosition! = nil
    var viewLoaded = false
    var nearbyEvents:[Event]! = nil
    var firebaseAdapter:FirebaseAdapter!
    var eventMarker:Event!
    @IBOutlet var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allNearbyEvents = nil
        viewLoaded = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.accessibilityElementsHidden = false
        mapView.myLocationEnabled = true
        userLocation = CLLocation(latitude: 34.4140, longitude: -119.8489)
        cam = GMSCameraPosition.cameraWithTarget(userLocation.coordinate, zoom: 18)
        mapView.camera = cam
        
        let uid = NSUserDefaults.standardUserDefaults().objectForKey("uid")
        
        firebaseAdapter = FirebaseAdapter()
        
        
        if firebaseAdapter.loggedIn()
        {
            firebaseAdapter.getSubscribedEvents()
            print(uid as! String)
        }
        else
        {
            print("This is view-only")
        }
        
        
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        //markersPlaced = false
        if(currentLongitude != nil && currentLattitude != nil){
            firebaseAdapter.getNearbyEvents(currentLongitude, currentLatitude: currentLattitude, maxDistance: maxDistance)
        }
        
        if firebaseAdapter.loggedIn()
        {
            firebaseAdapter.myEvents()
        }
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if viewLoaded{
            userLocation = locations[0]
            cam = GMSCameraPosition.cameraWithTarget(userLocation.coordinate, zoom: 18)
            mapView.camera = cam
            firebaseAdapter.getNearbyEvents(String(userLocation.coordinate.longitude), currentLatitude: String(userLocation.coordinate.latitude), maxDistance: maxDistance)
            
            currentLongitude = String(userLocation.coordinate.longitude)
            currentLattitude = String(userLocation.coordinate.latitude)
            viewLoaded = false
        }
        if (allNearbyEvents != nil && markersPlaced == false){
            for singleEvent in allNearbyEvents {
                let marker = GMSMarker()
                marker.map = mapView
                marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(singleEvent.latitude)!, longitude: CLLocationDegrees(singleEvent.longitude)!)
                marker.snippet = singleEvent.eventName
                marker.appearAnimation = kGMSMarkerAnimationPop
                marker.userData = singleEvent
                if(singleEvent.eventType == "warning"){
                    marker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
                }
                else if(singleEvent.eventType == "event"){
                    marker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
                }
                else{
                    marker.icon = GMSMarker.markerImageWithColor(UIColor.yellowColor())
                }
            }
            markersPlaced = true
        }
        if viewLoaded == false{
            var longitudeDelta = (Double(String(locations[0].coordinate.longitude))! - Double(userLocation.coordinate.longitude)) as Double!
            var latitudeDelta = (Double(locations[0].coordinate.latitude) - Double(userLocation.coordinate.latitude)) as Double!
            
            longitudeDelta = abs(longitudeDelta!) as Double!
            latitudeDelta = abs(latitudeDelta!) as Double!
            
            let distanceAway = sqrt((longitudeDelta * longitudeDelta) + (latitudeDelta * latitudeDelta))
            if (distanceAway >= 1.0){
                viewLoaded = true
                markersPlaced = false
                allNearbyEvents = nil
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        if(marker.userData == nil){
            print("nil")
        }
        eventMarker = marker.userData as! Event?
        print(eventMarker.eventName)
        print("didTapInfoWindow")
        performSegueWithIdentifier("eventSegue", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "eventSegue"){
            let yourNextViewController = (segue.destinationViewController as! EventDetailViewController)
            yourNextViewController.theEvent = eventMarker
            print("Performing Segue")
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backToLoginAction(sender: AnyObject) {
        performSegueWithIdentifier("backToLoginSegue", sender: self)
    }
    
}
