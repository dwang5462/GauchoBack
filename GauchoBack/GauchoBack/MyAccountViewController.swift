//
//  MyAccountViewController.swift
//  GauchoBack
//
//  Created by Carson Holoien on 5/3/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class MyAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //If user is not already logged in then segue back to login page.
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") == nil || CURRENT_USER.authData == nil
        {
            performSegueWithIdentifier("backToLoginSegue", sender: self)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logoutAction(sender: AnyObject) {
        
        print(CURRENT_USER.authData.uid, " has logged out.")
        CURRENT_USER.unauth()
        
        //***force facebook account to logout
        
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        
        FBSDKAccessToken.setCurrentAccessToken(nil)
        performSegueWithIdentifier("backToLoginSegue", sender: self)
    }
    
}
