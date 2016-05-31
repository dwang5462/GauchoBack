//
//  EventDetailViewController.swift
//  GauchoBack
//
//  Created by Carson Holoien on 5/25/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import UIKit
import GoogleMaps

class EventDetailViewController: UIViewController {

    @IBOutlet weak var eventTitle: UILabel!
    var theEvent: Event!
    var titleString: String!
    var cam:GMSCameraPosition! = nil
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var hostLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
   
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    
    
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
        eventNameLabel.text! += theEvent.eventName
        hostLabel.text! += theEvent.host
        locationLabel.text! += theEvent.location
        startTimeLabel.text! += theEvent.startTime
        endTimeLabel.text! += theEvent.endTime
        eventDescriptionTextView.text! = theEvent.eventDescription
        //self.eventTitle.text = theEvent.eventName
        self.navigationItem.title = theEvent.eventName
        // Do any additional setup after loading the view.
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

}
