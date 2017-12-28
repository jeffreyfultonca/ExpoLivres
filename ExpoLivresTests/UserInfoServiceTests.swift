//
//  UserInfoServiceTests.swift
//  ExpoLivres
//
//  Created by Jeffrey Fulton on 2015-09-26.
//  Copyright © 2015 Jeffrey Fulton. All rights reserved.
//

//import XCTest
//@testable import ExpoLivres
//
//class UserInfoServiceTests: XCTestCase {
//    
//    let mockPersistenceService = MockPersistenceService()
//    
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//        UserInfoService.persistenceService = mockPersistenceService
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//    
//    func testNoUserInfoResultsInInvalidUser() {
//        mockPersistenceService.mockUserOrganization = nil
//        mockPersistenceService.mockUserName = nil
//        mockPersistenceService.mockUserEmail = nil
//        
//        XCTAssertFalse(UserInfoService.isValid)
//        XCTAssertTrue(UserInfoService.isNotValid)
//    }
//    
//    func testValidUserInfoResultsInValidUser() {
//        mockPersistenceService.mockUserOrganization = "Valid Organization"
//        mockPersistenceService.mockUserName = "Valid Name"
//        mockPersistenceService.mockUserEmail = "valid@email.com"
//        
//        XCTAssertTrue(UserInfoService.isValid)
//        XCTAssertFalse(UserInfoService.isNotValid)
//    }
//    
//    func testNoOrganizationResultsInInvalidUser() {
//        mockPersistenceService.mockUserOrganization = nil
//        mockPersistenceService.mockUserName = "Valid Name"
//        mockPersistenceService.mockUserEmail = "valid@email.com"
//        
//        XCTAssertFalse(UserInfoService.isValid)
//        XCTAssertTrue(UserInfoService.isNotValid)
//    }
//    
//    func testNoNameResultsInInvalidUser() {
//        mockPersistenceService.mockUserOrganization = "Valid Organization"
//        mockPersistenceService.mockUserName = nil
//        mockPersistenceService.mockUserEmail = "valid@email.com"
//        
//        XCTAssertFalse(UserInfoService.isValid)
//        XCTAssertTrue(UserInfoService.isNotValid)
//    }
//    
//    func testNoEmailResultsInInvalidUser() {
//        mockPersistenceService.mockUserOrganization = "Valid Organization"
//        mockPersistenceService.mockUserName = "Valid Name"
//        mockPersistenceService.mockUserEmail = nil
//        
//        XCTAssertFalse(UserInfoService.isValid)
//        XCTAssertTrue(UserInfoService.isNotValid)
//    }
//    
//    func testInvalidEmailResultsInInvalidUser() {
//        mockPersistenceService.mockUserOrganization = "Valid Organization"
//        mockPersistenceService.mockUserName = "Valid Name"
//        mockPersistenceService.mockUserEmail = "Invalid Email"
//        
//        XCTAssertFalse(UserInfoService.isValid)
//        XCTAssertTrue(UserInfoService.isNotValid)
//    }
//}
//
//
