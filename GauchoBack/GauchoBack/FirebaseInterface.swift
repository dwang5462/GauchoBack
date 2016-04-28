//
//  FirebaseInterface.swift
//  GauchoBack
//
//  Created by Carson Holoien on 4/27/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import Foundation
import Firebase

class FirebaseInterface {
    
    
    //Base if you are not logged in.
    var userInfoRef = FIREBASE_REF
    
    var eventRef = FIREBASE_REF.childByAppendingPath("events")
    
    var usersRef = FIREBASE_REF.childByAppendingPath("users")
    
    
    
    init()
    {
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && CURRENT_USER.authData != nil
        {
            self.userInfoRef = FIREBASE_REF.childByAppendingPath("users").childByAppendingPath(CURRENT_USER.authData.uid).childByAppendingPath("user_info")
        }
    }
    
    func getUserInfo() -> [String]{
        let userInfo:[String] = ["empty"]
        
        return userInfo
    }
    
    
    //Sets user info using a string array
    func setUserInfo(firstName:String, lastName:String, email: String) -> Void{
        let userInfoDict = ["first_name": firstName, "last_name" :lastName, "email" : email]
        //saving info at user info location
        userInfoRef.setValue(userInfoDict)
    }
    
    
    //Returns true if an email exists in our system, false if not.
    func doesUserExist(emailToCheck:String)->Bool
    {
        var exists: Bool = false
        
        usersRef.queryOrderedByChild("email").observeEventType(.Value, withBlock:{ snapshot in
            if let curEmail = snapshot.value["email"] as? String{
                
                let curEmail = snapshot.value.objectForKey("email")! as! String
                
                print("matching email ", curEmail)
                print()
                if emailToCheck == curEmail
                {
                    exists = true
                    print("true")
                }
            }
        })
        
        return exists
    }
    
    
   /*
    func addEvent()->
    {
        
    }
    
    func deleteEvent()->
    {
        
    }
 */
}