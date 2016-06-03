//
//  GauchoBackTests.swift
//  GauchoBackTests
//
//  Created by Tristan T Starck on 4/11/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import XCTest
@testable import GauchoBack

class GauchoBackTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let testEvent = Event(eventName: "Game", eventDescription: "Soccer Game", location: "Soccer Field", longitude: "55.4", latitude: "56", startTime: "5:00", endTime: "6:00", host: "UCSB Athlethics", eventType: "event")
        XCTAssertTrue(testEvent.eventName == "Game")
        let fbAdapter = FirebaseAdapter()
        fbAdapter.setUserInfo("Bob", lastName: "Builder", email: "bobBuilder@yahoo.com")
        XCTAssertTrue(fbAdapter.getUserInfo() == ["Bob","Builder","bobBuilder@yahoo.com"])
        fbAdapter.addEvent(testEvent)
        XCTAssertTrue(fbAdapter.removeIllegalChars("$%^(#$") == "")
        fbAdapter.addAccount("bobBuilder@yahoo.com")
        XCTAssertTrue(fbAdapter.doesUserExist("bobBuilder@yahoo.com"))
        XCTAssertFalse(fbAdapter.loggedIn())
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
