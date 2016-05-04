//
//  CreatAccountViewController.swift
//  GauchoBack
//
//  Created by Carson Holoien on 4/18/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func createAccount(sender: AnyObject) {
        
        
        let firstName = self.firstNameTextField.text!
        let lastName = self.lastNameTextField.text!
        
        let email = self.emailTextField.text!
        let password = self.passwordTextField.text!
        
        if email != "" && password != ""
        {
           
            FIREBASE_REF.createUser(email, password: password, withValueCompletionBlock: { (error, authData) -> Void in
                
                if error == nil
                {
                    FIREBASE_REF.authUser(email, password: password, withCompletionBlock: { (error, authData)-> Void in
                        
                        if error == nil
                        {
                            NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                            NSUserDefaults.standardUserDefaults().setValue(authData.description, forKey: "description")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            
                            print(authData.uid)
                            
                            //
                            let firebaseAdapter = FirebaseAdapter()
                            firebaseAdapter.setUserInfo(firstName, lastName: lastName, email: email)
                            
                            firebaseAdapter.addAccount(email)
                            
                            self.performSegueWithIdentifier("createAccountSegue", sender: self)
                        }
                        else
                        {
                            print(error)
                        }
                    })
                }
                else
                {
                    print(error)
                }
                
            })
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "Enter Email and Password.", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    
    @IBAction func cancelAction(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
