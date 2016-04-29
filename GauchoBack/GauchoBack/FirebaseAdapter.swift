//
//  FirebaseInterface.swift
//  GauchoBack
//
//  Created by Carson Holoien on 4/27/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import Foundation
import Firebase

class FirebaseAdapter {
    
    
    //Base if you are not logged in.
    
    var eventRef = FIREBASE_REF.childByAppendingPath("events")
    
    var usersRef = FIREBASE_REF.childByAppendingPath("users")
    
    
    func getUserInfo() -> [String]{
        //let userInfoRef = FIREBASE_REF.childByAppendingPath("users").childByAppendingPath(CURRENT_USER.authData.uid).childByAppendingPath("user_info")
        let userInfo:[String] = ["empty"]
        
        
        
        return userInfo
    }
    
    
    //Sets user info using a string array
    func setUserInfo(firstName:String, lastName:String, email: String) -> Void{
        
        let userInfoRef = FIREBASE_REF.childByAppendingPath("users").childByAppendingPath(CURRENT_USER.authData.uid).childByAppendingPath("user_info")
        let userInfoDict = ["first_name": firstName, "last_name" :lastName, "email" : email]
        
        //saving info at user info location
        userInfoRef.setValue(userInfoDict)
    }
    
    //Removes all characters from email address that firebase does not allow for chil names.
    func removeBadChars(email:String)->String
    {
        var email = email.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range:nil)
        email = email.stringByReplacingOccurrencesOfString("#", withString: "", options: NSStringCompareOptions.LiteralSearch, range:nil)
        email = email.stringByReplacingOccurrencesOfString("$", withString: "", options: NSStringCompareOptions.LiteralSearch, range:nil)
        email = email.stringByReplacingOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.LiteralSearch, range:nil)
        email = email.stringByReplacingOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.LiteralSearch, range:nil)

        return email
    }
    
    //Returns true if an email exists in our system, false if not.
    func doesUserExist(emailToCheck:String)->Bool
    {
        let emailToCheck = removeBadChars(emailToCheck)
        
        var exists: Bool = false
        
        let accountRef = FIREBASE_REF.childByAppendingPath("accounts")
        
        accountRef.observeEventType(.Value, withBlock:
            { snapshot  in
            
            if snapshot.hasChild(emailToCheck)
            {
                print("child found")
                
                exists = true
                
            }
            else{
                //create an account
                }
        }, withCancelBlock: {error in
                print(error.description)
        })
        
        return exists
    }
    
    //Add account to our list of accounts.
    func addAccount(email:String)->Void
    {
        let email = removeBadChars(email)
        let addedAccount = ["added": true]
        FIREBASE_REF.childByAppendingPath("accounts").childByAppendingPath(email).setValue(addedAccount)
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