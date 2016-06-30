//
//  BaseService.swift
//  GauchoBack
//
//  Created by Carson Holoien on 4/18/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//
//https://www.youtube.com/watch?v=pHBLAWI4c1w
//

import Foundation
import Firebase

let BASE_URL = "https://gauchoback.firebaseio.com/"

let FIREBASE_REF = Firebase(url: BASE_URL)

var CURRENT_USER: Firebase
{
    let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
    
    let currentUser = Firebase(url: "\(FIREBASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
    return currentUser!
}