//
//  MapViewController.swift
//  GauchoBack
//
//  Created by Carson Holoien on 4/19/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
