//
//  UserInfoServiceTests.swift
//  ExpoLivres
//
//  Created by Jeffrey Fulton on 2015-09-26.
//  Copyright © 2015 Jeffrey Fulton. All rights reserved.
//

import XCTest
@testable import ExpoLivres

class UserInfoServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNoUserInfoResultsInInvalidUser() {
        let organization: String? = nil
        let name: String? = nil
        let email: String? = nil
        
        XCTAssertFalse(UserInfoService.isValid(organization: organization, name: name, email: email))
    }
    
    func testValidUserInfoResultsInvalidUser() {
        let organization = "Valid Organization"
        let name = "Valid Name"
        let email = "valid@email.com"
        
        XCTAssertTrue(UserInfoService.isValid(organization: organization, name: name, email: email))
    }
    
    func testNoOrganizationResultsInInvalidUser() {
        let organization: String? = nil
        let name = "Valid Name"
        let email = "valid@email.com"
        
        XCTAssertFalse(UserInfoService.isValid(organization: organization, name: name, email: email))
    }
    
    func testNoNameResultsInInvalidUser() {
        let organization = "Valid Organization"
        let name: String? = nil
        let email = "valid@email.com"
        
        XCTAssertFalse(UserInfoService.isValid(organization: organization, name: name, email: email))
    }
    
    func testNoEmailResultsInInvalidUser() {
        let organization = "Valid Organization"
        let name = "Valid Name"
        let email: String? = nil
        
        XCTAssertFalse(UserInfoService.isValid(organization: organization, name: name, email: email))
    }
    
    func testInvalidEmailResultsInInvalidUser() {
        let organization = "Valid Organization"
        let name = "Valid Name"
        let email = "Invalid Email"
        
        XCTAssertFalse(UserInfoService.isValid(organization: organization, name: name, email: email))
    }
}
