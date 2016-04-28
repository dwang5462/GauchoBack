//
//  LoginViewController.swift
//  GauchoBack
//
//  Created by Carson Holoien on 4/18/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate
{

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var viewOnlySegue: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    let fireBase = FirebaseInterface()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(FBSDKAccessToken.currentAccessToken() == nil)
        {
            print("Not currently logged in with Facebook")
        }
        else
        {
            //Either Creates an account or logs a user in to our firebase server with data from facebook.
            print("Currently logged in with Facebook")
            
            
            
            
            //createOrLoginFacebookAccountOnFirebase()
            
            
            
        }
        
        //Initialize the facebook button
        let loginButton = FBSDKLoginButton()
        //Allow the correct read permissions, so we get data from the account on facebook
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        //say wherethe facebook button will be locatedon the loginViewController
        loginButton.center = self.view.center
        //Make this view controller handle the output of the facebook button.
        loginButton.delegate = self
        
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        //Add button to View controller.
        self.view.addSubview(loginButton)
        
    }
    
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && CURRENT_USER.authData != nil
        {
            performSegueWithIdentifier("loginSegue", sender: self)
            print("Using Firebase login to segue to mapView")
        }
        else if(FBSDKAccessToken.currentAccessToken() != nil)
        {
            performSegueWithIdentifier("loginSegue", sender: self)
            
            createOrLoginFacebookAccountOnFirebase()
        
            print("Using Facebook login to segue to mapView")
        }
        
        
    }
    

    func loginToFirebase(email: String, password: String) ->Void{
        
        FIREBASE_REF.authUser(email, password: password, withCompletionBlock: { (error, authData)-> Void in
            
            
            if error == nil
            {
                NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                print("Logged In as ", authData.uid)
                print("Login complete using Firebase")
                self.performSegueWithIdentifier("loginSegue", sender: self);
            }
            else
            {
                print(error)
            }
        })
    }
    

    func facebookCreateAccountFireBase(firstName: String,lastName: String, email:String, password:String)->Void
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
                        
                        //Save values of user_info on firebase.
                        self.fireBase.setUserInfo(firstName, lastName: lastName, email: email)
                        
                        print(authData.uid)
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
    
    func createOrLoginFacebookAccountOnFirebase(){
        if((FBSDKAccessToken.currentAccessToken()) != nil)
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    print(result)
                    
                    let email = result.valueForKey("email") as! String!
                    let id = result.valueForKey("id") as! String!
                    let firstName = result.valueForKey("first_name") as! String!
                    let lastName = result.valueForKey("last_name") as! String!
                    
                    if(self.fireBase.doesUserExist(email)){
                        print("email exists")
                        self.loginToFirebase(email, password: id)
                    }
                    else{
                        print("email does not exist")
                        self.facebookCreateAccountFireBase(firstName, lastName: lastName, email: email, password: id)
                    }
                }
                else{
                    print(error.debugDescription)
                }
            })
        }
        
    }
    
    
    //Facebook login button to appear on screen. Used for debugging the facebook login process.
    func loginButton(loginButton:FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if error == nil
        {
            print("login complete FaceBook")

        }
        else
        {
            print(error.localizedDescription)
        }
    }
    
    //Facebook logout button
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("user did logout FaceBook")
    }
    
    //
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Action performed when the login button is pressed.
    @IBAction func loginAction(sender: AnyObject)
    {
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        
        if email != "" && password != ""
        {
            loginToFirebase(email!, password: password!)
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "Enter Email and Password.", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //Creating an account through Firebase.
    @IBAction func createAccountAction(sender: AnyObject) {
        performSegueWithIdentifier("createAccountSegue", sender: self)
    }
}
