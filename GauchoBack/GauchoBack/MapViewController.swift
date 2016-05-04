//
//  MapViewController.swift
//  GauchoBack
//
//  Created by Carson Holoien on 4/19/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var locationManager = CLLocationManager()
    var userLocation = CLLocation()
    var cam:GMSCameraPosition! = nil
    var viewLoaded = false
    @IBOutlet var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //prints out the user's current uid
        if uid != nil
        {
            print(uid as! String)
        }
        else
        {
            print("This is view-only")
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if viewLoaded{
            userLocation = locations[0]
            cam = GMSCameraPosition.cameraWithTarget(userLocation.coordinate, zoom: 18)
            mapView.camera = cam
            viewLoaded = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
