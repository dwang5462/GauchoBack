//
//  SettingsViewController.swift
//  GauchoBack
//
//  Created by Carson Holoien on 5/8/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

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

    @IBAction func logoutAction(sender: AnyObject) {
        print(CURRENT_USER.authData.uid, " has logged out.")
        CURRENT_USER.unauth()
        
        //***force facebook account to logout
        
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        
        FBSDKAccessToken.setCurrentAccessToken(nil)
        performSegueWithIdentifier("logoutSegue", sender: self)
    }
}
