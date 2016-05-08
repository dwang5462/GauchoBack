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
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var viewOnlySegue: UIButton!
    
    
    //Method called once the screen is loaded, prior to appearing.
    override func viewDidLoad() {
        super.viewDidLoad()
        if(FBSDKAccessToken.currentAccessToken() == nil)
        {
            print("Not currently logged in with Facebook")
        }
        else
        {
            print("Currently logged in with Facebook")
        }
        
        //Initialize the facebook button
        let loginButton = FBSDKLoginButton()
        //Allow the correct read permissions, so we get data from the account on facebook
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        //say where the facebook button will be located on the loginViewController
        loginButton.center = self.view.center
        //Make this view controller handle the output of the facebook button.
        loginButton.delegate = self
        
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        //Add button to View controller.
        self.view.addSubview(loginButton)
        
    }
    
    //This method is called once the screen is shown to the user.
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && CURRENT_USER.authData != nil
        {
            print("Using Firebase login to segue to mapView")
            performSegueWithIdentifier("loginSegue", sender: self)
        }
        else if FBSDKAccessToken.currentAccessToken() != nil
        {
            facebookProfileToFirebaseAccount()
            print("Using Facebook login to segue to mapView")
            performSegueWithIdentifier("loginSegue", sender: self)
            
        }
    }
    
    //Will either create a new account if facebook email has never been used before, or will use the firebase login if email has already been taken.
    func facebookCreateAccountOrLoginToFirebase(firstName: String,lastName: String, email:String, password:String)->Void
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
                        
                        let firebaseAdapter = FirebaseAdapter()
                        //Save values of user_info on firebase.
                        firebaseAdapter.setUserInfo(firstName, lastName: lastName, email: email)
                        firebaseAdapter.addAccount(email)
                        print("Added facebook member", firstName, " ", lastName, " to firebase with uid: ", authData.uid)
                    }
                    else
                    {
                        print(error)
                    }
                })
            }
            else
            {
                switch (error.code) {
                    
                    //If error code is 9 then the email has already been used.  This is usually a problem, but because this is all through Facebook.  If this error is thrown we will cover it by routing to the login with login to firebase method.
                    case -9:
                        print("facebook account already exists on firebase")
                        self.loginToFirebase(email, password: password)
                        break;
                    
                    
                    //We still want to print errors out if anything else happens.
                    default:
                        print(error)
                }
            }
        })
    }
    
    //Method to be called when logging in with facebook to register user in GauchoBack
    func facebookProfileToFirebaseAccount(){
        
        if((FBSDKAccessToken.currentAccessToken()) != nil)
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    
                    let email = result.valueForKey("email") as! String!
                    let id = result.valueForKey("id") as! String!
                    let firstName = result.valueForKey("first_name") as! String!
                    let lastName = result.valueForKey("last_name") as! String!
                    
                    if email != nil
                    {
                        self.facebookCreateAccountOrLoginToFirebase(firstName, lastName: lastName, email: email, password: id)
                    }
                    else
                    {
                            print("Email from facebook does not exist")
                    }
                }
                else
                {
                    print(error.debugDescription)
                }
            })
        }
    }
    
    //Facebook login button to appear on screen.
    func loginButton(loginButton:FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if error == nil
        {
            print("Login complete FaceBook")
        }
        else
        {
            print(error.localizedDescription)
        }
    }
    
    //Facebook logout button.
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out using FaceBook")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Given an email and password, we can login to Gauchoback with Firebase's authentication system.
    func loginToFirebase(email: String, password: String) ->Void
    {
        FIREBASE_REF.authUser(email, password: password, withCompletionBlock: { (error, authData)-> Void in
            
            if error == nil
            {
                NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                print()
                print("Logged In as ", authData.uid, ", using Firebase ")
                print()
                self.performSegueWithIdentifier("loginSegue", sender: self);
            }
            else
            {
                print(error)
            }
        })
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
    
    
    @IBAction func createAccountAction(sender: AnyObject) {
        performSegueWithIdentifier("createAccountSegue", sender: self)
    }
    //Creating an account through Firebase.
    
}
